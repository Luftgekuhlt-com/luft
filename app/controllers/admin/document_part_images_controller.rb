class Admin::DocumentPartImagesController < AdminController
  before_action :set_document
  before_action :set_document_part
  before_action :set_document_part_image, only: [:show, :edit, :update, :destroy, :move]

 # GET /document_parts/new
  def new
    @document_part_image = @document_part.images.build
    @document_part_image.image_type = params[:image_type] if params[:image_type].present?
    render layout: false
  end

  def edit
    render layout: false
  end

  def create
    @document_part_image = @document_part.images.build(document_part_image_params)
    if params[:slim].present?
      slim_current = JSON.parse(params[:slim].first) rescue {}
      slim_new = JSON.parse(params[:slim].last) rescue {}
      slim = slim_new["actions"].present? ? slim_new : slim_current
      if slim["actions"].present?  && @document_part_image.crop_actions != slim["actions"]
        @document_part_image.crop_actions = slim["actions"]
        @document_part_image.reprocess_image = true
      end
      if slim["input"].present? && slim["input"]["image"].present?
        img = Paperclip.io_adapters.for(slim["input"]["image"])
        img.original_filename = slim["input"]["name"]

        @document_part_image.image = img
      end
    end
    @document_part_image.save
    return redirect_to edit_admin_document_document_section_document_part_path(@document, @document_part.document_section, @document_part)
  end

  def update
    @document_part_image.attributes = document_part_image_params
    if params[:slim].present?
      slim_current = JSON.parse(params[:slim].first) rescue {}
      slim_new = JSON.parse(params[:slim].last) rescue {}
      slim = slim_new["actions"].present? ? slim_new : slim_current
      if slim["actions"].present?  && @document_part_image.crop_actions != slim["actions"]
        @document_part_image.crop_actions = slim["actions"]
        @document_part_image.reprocess_image = true
      end
      if slim["input"].present? && slim["input"]["image"].present?
        img = Paperclip.io_adapters.for(slim["input"]["image"])
        img.original_filename = slim["input"]["name"]

        @document_part_image.image = img
      end
    end
    @document_part_image.save
    return redirect_to edit_admin_document_document_section_document_part_path(@document, @document_part.document_section, @document_part)
  end

  def destroy
    @document_part_image.destroy
    
  end
  
  def move
    if params[:direction].present? && @document_part_image
      if params[:direction] == "down"
        other_img = @document_part.images.where("display_order >= ?", @document_part_image.display_order + 1).first
        if other_img.present?
          @document_part_image.display_order += 1
          other_img.display_order -= 1
          @document_part_image.save
          other_img.save
        end
      else
        other_img = @document_part.images.where("display_order <= ?", @document_part_image.display_order - 1).order("display_order desc").first
        if other_img.present?
          @document_part_image.display_order -= 1
          other_img.display_order += 1
          @document_part_image.save
          other_img.save
        end
      end
    end
    return redirect_to edit_admin_document_document_section_document_part_path(@document, @document_part.document_section, @document_part)
  end

  private
    def set_document
      @document = Document.find(params[:document_id])
    end
    def set_document_part
      @document_part = DocumentPart.find(params[:document_part_id])
    end
    def set_document_part_image
      @document_part_image = DocumentPartImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_part_image_params
      params.fetch(:document_part_image, {}).permit!
    end
end
