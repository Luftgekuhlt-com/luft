class Admin::GalleriesController < Admin::DocumentsController
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
    criteria[:where][:page_type] = 'gallery'
    criteria[:order] = {published_at: :desc}
    criteria[:limit] = per_page
    criteria[:offset] = @search_params[:page].present? ? (@search_params[:page].to_i - 1) * per_page : 0

    @documents = Document.search(term, criteria)
  end

  def show
  end

  def new
    @document = Document::Gallery.new(parent_id: params[:parent_id])
    render layout: false
  end

  def create
    @document = Document::Gallery.new(document_params)
    if @document.save
      flash[:notice] = "The page was successfully created"
    end
    return redirect_to admin_gallery_path(@document)
  end
  
  def admin_page
    'galleries'
  end
end