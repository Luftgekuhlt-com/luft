class Admin::DocumentPartsController < AdminController
  before_action :set_document
  before_action :set_document_section
  before_action :set_document_part, only: [:show, :edit, :update, :destroy, :move, :bulk, :bulk_upload]

  def show
  end

  # GET /document_parts/new
  def new
    @document_part = @document_section.parts.build({pane: params[:pane] || "main"})
    render layout: false
  end

  # GET /document_parts/1/edit
  def edit
  end

  # POST /document_parts
  # POST /document_parts.json
  def create
    parms = document_part_params.to_h.deep_dup.symbolize_keys
    parms[:document_id] = @document_section.document_id
    parms[:type] = 'DocumentPart::HtmlContent' if parms[:type].blank?
    @document_part = @document_section.parts.create(parms)
    redirect_to edit_admin_document_document_section_document_part_path(@document, @document_section, @document_part), notice: 'Content was successfully updated.' if @document_part.valid?
  end

  # PATCH/PUT /document_parts/1
  # PATCH/PUT /document_parts/1.json
  def update
    if @document_part.update(document_part_params)
      redirect_to admin_document_path(@document), notice: 'Content was successfully updated.'
    else
      render :edit
    end
  end

  def move
    if params[:direction].present?
      orig_order = @document_part.display_order
      if params[:direction] == "down"
        other_part = @document_section.parts.where("display_order >= ?", @document_part.display_order).where.not(id: @document_part.id).order("display_order asc").first
        if other_part.present?
          @document_part.display_order = orig_order + 1
          other_part.display_order = orig_order
          @document_part.save
          other_part.save
        end
      else
        other_part = @document_section.parts.where("display_order <= ?", @document_part.display_order).where.not(id: @document_part.id).order("display_order desc").first
        if other_part.present?
          @document_part.display_order = orig_order - 1
          other_part.display_order = orig_order
          @document_part.save
          other_part.save
        end
      end
    end
    if params[:pane].present?
      @document_part.update_attribute(:pane, params[:pane])
    end
    redirect_to admin_document_path(@document)
  end

  def bulk
    render layout: false
  end

  def bulk_upload
    if params[:images]
      params[:images].each { |image|
        @document_part.images.create(image: image)
      }
    end
    return redirect_to edit_admin_document_document_section_document_part_path(@document, @document_section, @document_part)
  end

  # DELETE /document_parts/1
  # DELETE /document_parts/1.json
  def destroy
    @document_part.destroy
  end

  def admin_section
    'content'
  end

  private
    def set_document
      @document = Document.find(params[:document_id])
    end
    def set_document_section
      @document_section = DocumentSection.find(params[:document_section_id])
    end
    def set_document_part
      @document_part = DocumentPart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_part_params
      params.fetch(:document_part, {}).permit!
    end
end
