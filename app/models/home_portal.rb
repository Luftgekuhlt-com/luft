class HomePortal < ApplicationRecord
  include StoreNestedAttributes
  include StoreWithType
  
  store :additional_data, accessors: [:crop_actions, :mobile_crop_actions], coder: JSON
  
  
  scope :primary, -> { where(category: 'primary') }
  scope :secondary, -> { where(category: 'secondary') }
  scope :visible, -> { where("hidden = ? AND start_date <= ? AND end_date > ?", false, Date.today, Date.today) }
  
  has_attached_file :main_image,
    path: "home_portals/:id/main-image/:style.:extension",
    styles: {
      cropped: ->(instance) {
        instance.has_crop_actions? ? "" : "800x300>"
      }
    },
    convert_options: {
      cropped:  ->(instance) {
        Paperclip.convert_options_from_crop_actions(instance.crop_actions)
      }
    }
    do_not_validate_attachment_file_type :main_image
    
  has_attached_file :mobile_image,
    path: "home_portals/:id/mobile-image/:style.:extension",
    styles: {
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
  before_save :set_creator
  before_save :set_order
  
  def self.preferred_image_dimensions
     [800, 300]
  end

  def preferred_image_dimensions
    [800, 300]
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


  private
  
  def set_creator
    self.created_by ||= current_user.try(:id) rescue nil
  end
  
  def validate_dates
    self.start_date ||= Date.today
    self.end_date = 2.months.from_now unless end_date.present? && end_date > self.start_date
  end
  
  def set_order
    self.display_order ||= HomePortal.maximum(:display_order) + 1 rescue HomePortal.all.count + 1
  end
end
