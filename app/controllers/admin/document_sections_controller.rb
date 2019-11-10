class Admin::DocumentSectionsController < AdminController
  before_action :set_document
  before_action :set_document_section, only: [:update, :destroy, :move]

  # POST /document_sections
  # POST /document_sections.json
  def create
    document_section_params[:layout] ||= 'full'
    @document_section = @document.sections.create(document_section_params)
    redirect_to admin_document_path(@document)
  end

  # PATCH/PUT /document_sections/1
  # PATCH/PUT /document_sections/1.json
  def update
    @document_section.update(document_section_params)
    respond_to do |format|
      format.html { redirect_to admin_document_path(@document), notice: 'Section was successfully updated.' }
      format.json { head :no_content }
    end
  end
  
  def move
    if params[:direction].present?
      orig_order = @document_section.display_order
      if params[:direction] == "down"
        other_part = @document.sections.where("display_order > ?", @document_section.display_order).order("display_order asc").first
        if other_part.present?
          @document_section.display_order = orig_order + 1
          other_part.display_order = orig_order
          @document_section.save
          other_part.save
        end
      else
        other_part = @document.sections.where("display_order < ?", @document_section.display_order).order("display_order desc").first
        if other_part.present?
          @document_section.display_order = orig_order - 1
          other_part.display_order = orig_order
          @document_section.save
          other_part.save
        end
      end
    end
    if params[:pane].present?
      @document_section.update_attribute(:pane, params[:pane])
    end
    redirect_to admin_document_path(@document)
  end

  # DELETE /document_sections/1
  # DELETE /document_sections/1.json
  def destroy
    @document_section.destroy
    respond_to do |format|
      format.html { redirect_to admin_document_path(@document), notice: 'Section was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def set_document
      @document = Document.find(params[:document_id])
    end
    def set_document_section
      @document_section = DocumentSection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_section_params
      params.fetch(:document_section, {}).permit!
    end
end
