class ImageInput < SimpleForm::Inputs::Base
  include ActionView::RecordIdentifier

  def input(wrapper_options=nil)
    template.render(partial: "inputs/image", locals: { input: self, builder: @builder })
  end

  # =================================================================
  # image (attachment) convenience methods...
  # =================================================================

  def image
    object.send(attribute_name.to_sym)
  end

  def image_url
    image.url(image_style || :original) if image.present?
  end

  def image_or_default_url
    image_url || default_image_url
  end

  def default_image?
    !image.present? && default_image_url.present?
  end

  def image_style
    input_options[:image_style]
  end

  def accept
    input_options.fetch(:accept, "image/*")
  end

  def default_image_url
    input_options.fetch(:default_image_url, attachment_default_url)
  end

  def image_html_style
    input_options[:image_html_style]
  end

  def image_max_height
    input_options.fetch(:image_max_height, "#{preview_max_width}px")
  end

  def image_max_width
    input_options.fetch(:image_max_width, "#{preview_max_width}px")
  end

  # =================================================================
  # image removal
  # =================================================================

  def removable?
    object.respond_to?(:"remove_#{attribute_name}=")
  end

  def remove_attribute_name
    "#{object_name}[remove_#{attribute_name}]"
  end

  # =================================================================
  # image preview
  # =================================================================

  def preview_max_height
    geometry = image_style_geometry
    geometry.present? ? geometry.height.to_i : 100
  end

  def preview_max_width
    geometry = image_style_geometry
    geometry.present? ? geometry.width.to_i : 100
  end

  def preview_class
    classes = []
    classes << "default" if default_image?
    classes << "hidden" unless image_or_default_url.present?
    classes.join(" ")
  end

  def preview_style
    "max-height:#{image_max_height};max-width:#{image_max_width};#{image_html_style}"
  end

  # =================================================================
  # DOM IDs
  # =================================================================

  def container_id
    element_id("image_input")
  end

  def modal_id
    element_id("upload_modal")
  end

  def modal_title
    input_options.fetch(:title, "Upload Image")
  end

  protected

  def element_id(suffix=nil)
    [dom_id(object, attribute_name), suffix].compact.join("_")
  end

  def image_style_geometry
    Paperclip::Geometry.parse(image.styles[image_style].geometry) if image_style.present?
  end

  def attachment_default_url
    # if the Paperclip default URL is being used,
    # return nil, we don't want to use that one...
    return nil if image.options[:default_url] == "/:attachment/:style/missing.png"

    # otherwise, interpolate the default url...
    # cl.linked_in.interpolator.interpolate(cl.linked_in.options[:default_url], cl.linked_in, :thumb)
    generator = image.options[:url_generator].new(image, image.options)
    image.interpolator.interpolate(generator.send(:default_url), image, image_style || image.default_style)
  end
end