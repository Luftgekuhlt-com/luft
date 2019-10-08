class Document < ApplicationRecord
  include StoreNestedAttributes
  include StoreWithType
  searchkick index_name: [Rails.env, "pages"].join("_"), inheritance: true

  store :meta_data, accessors: [:meta_description, :meta_keywords, :browser_title, :facebook_title, :facebook_image, :facebook_description, :twitter_title, :twitter_image, :twitter_description, :banner_title], coder: JSON
  store :additional_data, accessors: [:crop_actions, :article_date], coder: JSON

  has_many :document_categories, dependent: :delete_all
  has_many :categories, through: :document_categories
  has_many :sections, class_name: "DocumentSection", dependent: :delete_all
  has_many :parts, through: :sections, class_name: "DocumentPart", dependent: :delete_all

  scope :active, -> { where("archived is null OR archived = ?", false) }
  scope :visible, -> { where("(archived is null OR archived = ?) AND hidden != ?", false, false) }
  scope :search_import, -> { includes(:categories, sections: [:images]) }
  scope :pages, -> { where(type: 'Document::Page') }

  def search_data
    attrs = self.attributes.slice("id", "title", "slug", "parent_id", "subtitle", "meta_data", "order", "hidden", "archived", "published_at", "created_at", "updated_at", "expires_at", "featured", "home")
    attrs["hidden"] ||= false
    attrs["archived"] ||= false
    attrs["home"] ||= false
    attrs["published_at"] ||= created_at
    attrs["excerpt"] = self.excerpt
    attrs["expires_at"] ||= 10.years.from_now
    attrs["main_image"] = (main_image.present? ? main_image_url : "") rescue ""
    attrs["thumb_image"] = thumb_image_url rescue ""
    attrs["has_thumb"] = thumb_image_url.present?
    attrs["site_url"] = site_url
    attrs["categories"] = categories.map(&:slug)
    attrs["search_text"] = search_text
    attrs["page_type"] = page_type
    attrs
  end

  has_attached_file :main_image,
    path: "pages#{Rails.env.production? ? "" : "-qa"}/:id/main-image/:style.:extension",
    styles: {
      cropped: ->(instance) {
        instance.has_crop_actions? ? "" : "#{instance.preferred_image_dimensions.map(&:to_s).join("x")}#"
      },
      thumb: {
        geometry: "600x400>"
      }
    },
    convert_options: {
      cropped:  ->(instance) {
        Paperclip.convert_options_from_crop_actions(instance.crop_actions)
      }
    }
    do_not_validate_attachment_file_type :main_image

  attr_accessor :processing_cropped_image, :reprocess_main_image

  after_commit do
    puts "document commit: #{id} - #{processing_cropped_image} - #{reprocess_main_image}"
    if previous_changes.has_key?(:crop_actions) || reprocess_main_image
      unless self.processing_cropped_image
        self.processing_cropped_image = true
        main_image.reprocess!(:cropped)
      end
    end

  end


  before_validation :set_slug
  before_create :set_creator
  after_create :init_sections

  validates_uniqueness_of :slug

  PAGE_TYPES = {
    'Document::Page': 'Content Page',
    "Document::LandingPage": "Landing Page"
  }

  SECTION_LAYOUTS = {
    'full': 'Full Width',
    "halves": "2 Columns",
    "left-pane": "Left Side Pane",
    "right-pane": "Right Side Pane",
    "thirds": "3 Columns"
  }

  PART_TYPES = {
    "DocumentPart::HtmlContent": "HTML Content",
    "DocumentPart::ImageGallery": "Image Gallery",
    "DocumentPart::Slideshow": "Full-Width Image or Slideshow",
    "DocumentPart::Video": "Video Player",
    "DocumentPart::NewsLinksList": "News Links List",
    "DocumentPart::PressReleaseList": "Press Release List",
    "DocumentPart::PerformanceHistoriesList": "Performance Histories"
  }

  def self.preferred_image_dimensions(page_type)
    case page_type.underscore
    when "story"
      [2200, 800]
    else
      [2200, 600]
    end
  end

  def preferred_image_dimensions
    self.class.preferred_image_dimensions(page_type)
  end

  def parent
    if parent_id.present?
      return Document.find_by(id: parent_id) rescue nil
    end
  end

  def site_url
    @site_url = begin
      url = "/#{slug}"
      if parent.present?
        url = "#{parent.site_url}#{url}"
      end
      url
    end
  end

  def hierarchical_display
    @hierarchical_display = begin
      display = title
      if parent.present?
        display = "#{parent.hierarchical_display} &mdash; #{display}"
      end
      display
    end
  end

  def parent_pages
    @parent_pages = begin
      parents = []
      if parent.present?
        parents << parent.id
        parents += parent.parent_pages
      end
      parents
    end
  end

  def excerpt
    sections.where(type: "DocumentPart::HtmlContent").first.try(:content) rescue ""
  end

  def self.types_and_counts(query=nil,include_hidden=false, include_archived=false, featured_only=false, home_only=false)
    results = {}
    criteria = {}
    term = query.presence || "*"

    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "pages"].join("_")

    criteria[:where] = { }
    criteria[:where][:hidden] = false unless include_hidden
    criteria[:where][:archived] = false unless include_archived
    criteria[:where][:featured] = true if featured_only
    criteria[:where][:home] = true if home_only
    criteria[:aggs] = [:page_type]
    criteria[:limit] = 5000
    search = Document.search(term, criteria)
    search.aggs["page_type"]["buckets"].each do |pt|
      results[pt["key"]] = pt["doc_count"]
    end
    results
  end

  def friendly_type
    self.class.name.split("::").last.underscore.humanize.titleize
  end

  def slim_dimension_string
    preferred_image_dimensions.map(&:to_s).join(",")
  end

  def slim_crop_actions_string
    return unless crop_actions.present? && crop_actions.keys.any?
    actions = crop_actions["crop"]

    [
      actions["x"],
      actions["y"],
      actions["width"],
      actions["height"]
    ].join(",")
  end

  def has_crop_actions?
    crop_actions.present? && crop_actions.keys.any?
  end


 # this is to handle assigning base64 encoded images
  def main_image_with_base64=(data)
    image = data

    if data.is_a?(String) && data.include?("data:image")
      parts = data.split(',')

      meta = parts.first
      content_type =  meta.split(';').first.gsub!('data:', '')
      extension = content_type.split('/').last
      extension = (extension == 'jpeg') ? 'jpg' : extension

      image = Paperclip.io_adapters.for(data)

      image.content_type = content_type
      image.original_filename = [rand(10_000), extension].join('.')

    end

    self.main_image_without_base64 = image
  end

  alias_method_chain :main_image=, :base64

  def main_image_url
    main_image.url(:cropped)
  end

  def thumb_image_url
    main_image.url(:thumb)
  end

  def search_text
    [title, slug, sections.map(&:search_text)].join("\n")
  end

  def currently_featured?
    featured? && !hidden? && !archived? && (published_at.present? && published_at < Time.now) && (expires_at.nil? || expires_at > Time.now)
  end

  def currently_home?
    home? && !hidden? && !archived? && (published_at.present? && published_at < Time.now) && (expires_at.nil? || expires_at > Time.now)
  end

  def self.featured_items(page_type=nil, limit=3)
    criteria = {}
    per_page = limit

    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "pages"].join("_")

    criteria[:where] = { }
    criteria[:where][:hidden] = false
    criteria[:where][:archived] = false
    criteria[:where][:featured] = true
    criteria[:where][:has_thumb] = true
    criteria[:where][:page_type] = page_type if page_type.present?
    criteria[:where][:published_at] = {lt: Time.now}
    criteria[:where][:expires_at] = {gt: Time.now}
    criteria[:order] = {published_at: :desc}
    criteria[:limit] = per_page

    @documents = Document.search("*", criteria)
  end

  def self.home_items(page_type=nil, limit=3)
    criteria = {}
    per_page = limit

    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "pages"].join("_")

    criteria[:where] = { }
    criteria[:where][:hidden] = false
    criteria[:where][:archived] = false
    criteria[:where][:home] = true
    criteria[:where][:has_thumb] = true
    criteria[:where][:page_type] = page_type if page_type.present?
    criteria[:where][:published_at] = {lt: Time.now}
    criteria[:where][:expires_at] = {gt: Time.now}
    criteria[:order] = {featured: :desc, published_at: :desc}
    criteria[:limit] = per_page

    @documents = Document.search("*", criteria)
  end

  def partial_page?
    false
  end

  def production_page?
    false
  end

  private


  def set_slug
    self.slug = self.title.parameterize if title.present? && slug.blank?
  end

  def set_creator
    self.created_by = current_user.try(:id) rescue nil
    self.published_at ||= self.created_at
  end

  def init_sections
    sec = self.sections.create(display_order: 0, layout: 'full')
    sec.parts.create({
      type: "DocumentPart::HtmlContent",
      document_id: sec.document_id,
      title: "",
      content: "",
      pane: "main",
      display_order: 1
      })
  end
end
