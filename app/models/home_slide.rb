class HomeSlide < ApplicationRecord
  include StoreNestedAttributes
  include StoreWithType

  store :additional_data, accessors: [:crop_actions, :mobile_crop_actions, :custom_slide_duration], coder: JSON


  scope :active, -> { where("archived is null OR archived = ?", false) }
  scope :visible, -> { where("(archived is null OR archived = ?) AND hidden != ?", false, false) }

  ANCHOR_OPTIONS = ["left", "top-left", "top-center", "center", "top-right", "right", "bottom-right", "bottom-center", "bottom-left"]
  SLIDE_TYPES = %w(basic video)
  DEFAULT_SLIDE_DURATION = 8

  def basic?
    slide_type == 'basic'
  end

  def video?
    slide_type == 'video'
  end

  def acclaim?
    slide_type == 'acclaim'
  end

  def custom?
    slide_type == 'custom'
  end

  def slide_duration
    custom_slide_duration.to_i.positive? ? custom_slide_duration.to_i : DEFAULT_SLIDE_DURATION
  end

  has_attached_file :main_image,
    path: "home_slides/:id/main-image/:style.:extension",
    styles: {
      thumb: "150x75>",
      cropped: ->(instance) {
        instance.has_crop_actions? ? "" : "2500x800>"
      }
    },
    convert_options: {
      cropped:  ->(instance) {
        Paperclip.convert_options_from_crop_actions(instance.crop_actions)
      }
    }
    do_not_validate_attachment_file_type :main_image

  has_attached_file :mobile_image,
    path: "home_slides/:id/mobile-image/:style.:extension",
    styles: {
      thumb: "80x80>",
      cropped: ->(instance) {
        instance.has_crop_actions? ? "" : "600x600>"
      }
    },
    convert_options: {
      cropped:  ->(instance) {
        Paperclip.convert_options_from_crop_actions(instance.mobile_crop_actions)
      }
    }
    do_not_validate_attachment_file_type :mobile_image



  attr_accessor :processing_cropped_image, :reprocess_main_image, :preview_image_url, :processing_cropped_mobile_image, :reprocess_mobile_image, :preview_mobile_image_url

  after_commit do
    puts "document commit: #{id} - #{processing_cropped_image} - #{reprocess_main_image}"
    if previous_changes.has_key?(:crop_actions) || reprocess_main_image
      unless self.processing_cropped_image
        self.processing_cropped_image = true
        main_image.reprocess!(:cropped)
      end
    end
    if previous_changes.has_key?(:mobile_crop_actions) || reprocess_mobile_image
      unless self.processing_cropped_mobile_image
        self.processing_cropped_mobile_image = true
        mobile_image.reprocess!(:cropped)
      end
    end
  end

  before_validation :validate_dates
  before_create :set_creator
  before_create :set_order

  def self.preferred_image_dimensions
     [2500, 800]
  end

  def preferred_image_dimensions
    [2500, 800]
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
    if main_image.blank?
      return preview_image_url
    end
    main_image.url(:cropped)
  end

  #mobile image

  def self.preferred_mobile_image_dimensions
     [600, 600]
  end

  def preferred_mobile_image_dimensions
    [600, 600]
  end

  def slim_mobile_dimension_string
    preferred_mobile_image_dimensions.map(&:to_s).join(",")
  end

  def slim_mobile_crop_actions_string
    return unless mobile_crop_actions.present? && mobile_crop_actions.keys.any?
    actions = mobile_crop_actions["crop"]

    [
      actions["x"],
      actions["y"],
      actions["width"],
      actions["height"]
    ].join(",")
  end

  def has_mobile_crop_actions?
    mobile_crop_actions.present? && mobile_crop_actions.keys.any?
  end

 # this is to handle assigning base64 encoded images
  def mobile_image_with_base64=(data)
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

    self.mobile_image_without_base64 = image
  end

  alias_method_chain :mobile_image=, :base64

  def mobile_image_url
    if mobile_image.blank?
      return preview_mobile_image_url
    end
    mobile_image.url(:cropped)
  end


  def has_video?
    video_url.present?
  end

  def html5?
    video_url.downcase.include?(".mp4")
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
    video_url.split("?").first.split("/").last
  end

  def player_html
    markup = ""
    if vimeo?
      markup = %Q(<iframe webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen="" src="//player.vimeo.com/video/#{vimeo_id}?title=0&byline=0&portrait=0&color=ffffff&autoplay=1&loop=1" style="width:100%;max-width:100%;height:600px;" frameborder="0"></iframe>)
    end
    if youtube?
      markup = %Q(<iframe width="100%" height="600" src="https://www.youtube.com/embed/#{youtube_id}?rel=0&autoplay=1" frameborder="0" style="width:100%;max-width:100%;" allowfullscreen></iframe>)
    end
    if html5?
    markup = %Q(<div class="html5-video-wrap"><video width="100%" preload="auto" height="100%" muted controls><source src="#{video_url}" type="video/mp4"></video></div>)
    end
    markup
  end

  private

  def set_creator
    self.created_by = current_user.try(:id) rescue nil
  end

  def validate_dates
    self.start_date ||= Date.today
    self.end_date = 2.months.from_now unless end_date.present? && end_date > self.start_date
  end

  def set_order
    self.display_order = HomeSlide.maximum(:display_order) + 1 rescue nil unless display_order.present?
  end
end
