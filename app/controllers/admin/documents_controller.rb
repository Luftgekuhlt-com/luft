class Admin::DocumentsController < AdminController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  def index
    criteria = {}
    @search_params = params[:search] || {}
    per_page = (params[:per_page] || "25").to_i
    term = @search_params[:q].presence || "*"

    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "pages"].join("_")

    criteria[:where] = { }
    criteria[:where][:hidden] = false unless (@search_params[:include_hidden].present? && !!(@search_params[:include_hidden]))
    criteria[:where][:archived] = false unless (@search_params[:include_archived].present? && !!(@search_params[:include_archived]))
    criteria[:where][:page_type] = 'page'
    criteria[:order] = {published_at: :desc}
    criteria[:limit] = per_page
    criteria[:offset] = @search_params[:page].present? ? (@search_params[:page].to_i - 1) * per_page : 0

    @documents = Document.search(term, criteria)
  end

  def show
    redirect_to admin_content_areas_path if @document.page_type == "content_areas"
    redirect_to admin_build_page_path(@document) if @document.build_page?
    redirect_to admin_past_event_path(@document) if @document.past_event?
    redirect_to admin_gallery_path(@document) if @document.gallery?
    redirect_to admin_storyline_path(@document) if @document.storyline?
  end

  def homepage
    @document = home_page
  end

  def new
    @document = Document.new
    render layout: false
  end

  def create
    @document = Document.new(document_params.merge(type: 'Document::Page'))
    if @document.save
      flash[:notice] = "The page was successfully created"
    end
    return redirect_to admin_document_path(@document)
  end

  def edit
  end

  def update
   @document.attributes = document_params
   if params[:slim].present?
      slim_current = JSON.parse(params[:slim].first) rescue {}
      slim_new = JSON.parse(params[:slim].last) rescue {}
      slim = slim_new["actions"].present? ? slim_new : slim_current
      if slim["actions"].present?  && @document.crop_actions != slim["actions"]
        @document.crop_actions = slim["actions"]
        @document.reprocess_main_image = true
      end
      if slim["input"].present? && slim["input"]["image"].present?
        img = Paperclip.io_adapters.for(slim["input"]["image"])
        img.original_filename = slim["input"]["name"]

        @document.main_image = img
      end
    end
    if @document.save

      flash[:notice] = "The page was successfully updated"
    end
    return redirect_to admin_document_path(@document)
  end

  def destroy
    if @document.archived?
      if @document.update_attribute(:archived, false)
        flash[:notice] = "The document was successfully unarchived"
      end
    else
      if @document.update_attribute(:archived, true)
        @document.update(slug: "#{@document.slug}-archived")
        @document.reindex
        flash[:notice] = "The document was successfully archived"
      end
    end
    return redirect_to admin_documents_path
  end

  def admin_section
    if @document.present?
      return 'home' if %w[home_page].include?(@document.page_type)
    end
    'content'
  end
  
  def admin_page
    'content-pages'
  end

  private
  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.fetch(:document, {}).permit!
  end

end