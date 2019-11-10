class DocumentPartImage < ApplicationRecord
  belongs_to :document_part, touch: true  
  before_save :set_order
  
  attr_accessor :manual_thumb, :uncropped, :image_type
    serialize :crop_actions, Hash
    
    has_attached_file :image, 
    path: "pages#{Rails.env.production? ? "" : "-qa"}/:document_key/images/:id/:style.:extension", 
    styles: {
      cropped: ->(instance) {
        instance.has_crop_actions? ? "" : "#{instance.preferred_image_dimensions.map(&:to_s).join("x")}#"
      },
      medium: {
        geometry: "2200x1200>"
      }, 
      thumb: {
        geometry: "600x400>"
      }
    },
    convert_options: {
      cropped:  ->(instance) {
        Paperclip.convert_options_from_crop_actions(instance.crop_actions)
      }
    }, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    
    Paperclip.interpolates :document_key do |attachment, style|
      attachment.instance.document_part.document.id rescue "unmapped"
    end
  attr_accessor :processing_cropped_image, :reprocess_image
  
  after_commit do
    puts "document commit: #{id} - #{processing_cropped_image} - #{reprocess_image}"
    if previous_changes.has_key?(:crop_actions) || reprocess_image
      unless self.processing_cropped_image
        self.processing_cropped_image = true
        image.reprocess!(:cropped)
      end
    end
    
  end
  
  def search_text
    [title, caption].select{|x| !x.blank?}.join("\n")
  end

  def set_order
    self.display_order = document_part.images.maximum(:display_order) + 1 rescue document_part.images.count + 1 unless display_order.present? || document_part.nil?
  end
  
  def self.preferred_image_dimensions(part_type)
    case part_type
    when "cast_list"
      [800, 800]
    when "hero_spot"
      [1100, 800]
    else
      [800, 600]
    end
  end

  def preferred_image_dimensions
    self.class.preferred_image_dimensions(document_part&.part_type || image_type)
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
  def image_with_base64=(data)
    img = data

    if data.is_a?(String) && data.include?("data:image")
      parts = data.split(',')

      meta = parts.first
      content_type =  meta.split(';').first.gsub!('data:', '')
      extension = content_type.split('/').last
      extension = (extension == 'jpeg') ? 'jpg' : extension

      img = Paperclip.io_adapters.for(data)

      img.content_type = content_type
      img.original_filename = [rand(10_000), extension].join('.')
      
    end

    self.image_without_base64 = img
  end

  alias_method_chain :image=, :base64

  def image_url
    image.url(:cropped)
  end
  
  def thumb_image_url
    image.url(:thumb)
  end
end
