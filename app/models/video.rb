class Video < ApplicationRecord
  include StoreNestedAttributes
  include StoreWithType
  searchkick index_name: [Rails.env, "videos"].join("_"), inheritance: true
  
  store :additional_data, accessors: [:crop_actions], coder: JSON
  has_many :video_tags, dependent: :delete_all
  has_many :tags, through: :video_tags
  accepts_nested_attributes_for :video_tags
  
  scope :search_import, -> { includes(:tags) }
  
  def search_data
    attrs = self.attributes.slice("id", "title", "slug", "sub_title", "video_url", "caption", "published_at", "created_at", "updated_at")
    attrs["thumb_image"] = (thumb_image.present? ? thumb_image_url : "") rescue ""
    attrs["has_thumb"] = thumb_image.present?
    attrs["categories"] = tags.where(is_category: true).map(&:slug)
    attrs["tags"] = tags.where(is_category: false).map(&:slug)
    attrs["search_text"] = search_text
    attrs
  end
  
  scope :visible, -> { where("(hidden != ?", false, false) }
  
  validates_uniqueness_of :slug
  
  has_attached_file :thumb_image,
    path: "videos#{Rails.env.production? ? "" : "-qa"}/:id/thumb-image/:style.:extension",
    styles: {
      cropped: ->(instance) {
        instance.has_crop_actions? ? "" : "#{instance.preferred_image_dimensions.map(&:to_s).join("x")}#"
      }
    },
    convert_options: {
      cropped:  ->(instance) {
        Paperclip.convert_options_from_crop_actions(instance.crop_actions)
      }
    }
    do_not_validate_attachment_file_type :thumb_image
    

  attr_accessor :processing_cropped_image, :reprocess_thumb_image
  
  after_commit do
    puts "document commit: #{id} - #{processing_cropped_image} - #{reprocess_thumb_image}"
    if previous_changes.has_key?(:crop_actions) || reprocess_thumb_image
      unless self.processing_cropped_image
        self.processing_cropped_image = true
        thumb_image.reprocess!(:cropped)
      end
    end
  end
  
  
  before_validation :set_slug
  before_create :set_creator
  
  def self.preferred_image_dimensions
     [600, 400]
  end

  def preferred_image_dimensions
    [600, 400]
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
  def thumb_image_with_base64=(data)
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

    self.thumb_image_without_base64 = image
  end

  alias_method_chain :thumb_image=, :base64

  def thumb_image_url
    thumb_image.url(:cropped)
  end
  
  def full_title
     [title, sub_title].select{|x| !x.blank?}.join(" | ")
  end
  
  
  def vimeo?
    video_url.downcase.include?("vimeo")
  end
  
  def vimeo_id
    video_url.split("?").first.split("/").last
  end

  def youtube?
    video_url.downcase.include?("youtube") || video_url.downcase.include?("youtu.be")
  end
  
  def youtube_id
    video_url.include?("v=") ? video_url.split("v=").last.split("&").first : video_url.split("?").first.split("/").last
  end
  
  def player_html
    markup = ""
    if vimeo?
      markup = %Q(<iframe webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen="" src="//player.vimeo.com/video/#{vimeo_id}?title=0&byline=0&portrait=0&color=ffffff&autoplay=1&loop=1" style="width:100%;max-width:100vw;height:56vw;max-height:90vh;" frameborder="0"></iframe>)
    end
    if youtube?
      markup = %Q(<iframe width="100%" height="600" src="https://www.youtube.com/embed/#{youtube_id}?rel=0&autoplay=1" frameborder="0" style="width:100%;max-width:100vw;height:56vw;max-height:90vh;" allowfullscreen></iframe>)
    end
    markup
  end
  
  def tag_names
    tags.map(&:name) rescue []
  end
  
  def tag_slugs
    tags.map(&:slug) rescue []
  end
  
  def similar_videos(limit=10)
    criteria = {}
    per_page = limit
    
    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "videos"].join("_")
    
    criteria[:where] = { }
    criteria[:where][:tags] = tags.map(&:slug)
    criteria[:where][:id] = {not: id}
    criteria[:order] = {_score: :desc}
    criteria[:limit] = per_page
    criteria[:operator] = "or"
      
    items = Video.search("*", criteria)
    items
  end
  
  def search_text
    [title, sub_title, caption].join("\n")
  end
  
  def self.categories_and_counts
    results = {}
    criteria = {}
    term = "*"
    
    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "videos"].join("_")
    
    criteria[:where] = { }
    criteria[:aggs] = [:categories]
    criteria[:limit] = 5000
    search = Video.search(term, criteria)
    search.aggs["categories"]["buckets"].each do |pt|
      results[pt["key"]] = pt["doc_count"]
    end
    results
  end
  
  def self.tags_and_counts
    results = {}
    criteria = {}
    term = "*"
    
    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "videos"].join("_")
    
    criteria[:where] = { }
    criteria[:aggs] = [:tags]
    criteria[:limit] = 5000
    search = Video.search(term, criteria)
    search.aggs["tags"]["buckets"].each do |pt|
      results[pt["key"]] = pt["doc_count"]
    end
    results
  end
  
  def self.items_by_category(tag=nil, limit=10, exclude_ids=[])
    criteria = {}
    per_page = limit
    
    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "videos"].join("_")
    
    criteria[:where] = { }
    criteria[:where][:categories] = tag if tag.present?
    criteria[:where][:id] = {not: exclude_ids} if exclude_ids.any?
    criteria[:order] = {published_at: :desc}
    criteria[:limit] = per_page
      
    items = Video.search("*", criteria)
    items
  end
  
  def self.items_by_tag(tag=nil, limit=10, exclude_ids=[])
    criteria = {}
    per_page = limit
    
    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "videos"].join("_")
    
    criteria[:where] = { }
    criteria[:where][:tags] = tag if tag.present?
    criteria[:where][:id] = {not: exclude_ids} if exclude_ids.any?
    criteria[:order] = {published_at: :desc}
    criteria[:limit] = per_page
      
    items = Video.search("*", criteria)
    items
  end
  
  private

  
  def set_slug
    self.slug = self.title.parameterize if title.present? && slug.blank?
    self.published_at = Time.now if published_at.blank?
  end
  
  def set_creator
    self.created_by = current_user.try(:id) rescue nil
  end
end
