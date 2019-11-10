class Admin::PastEventsController < Admin::DocumentsController
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
    criteria[:where][:page_type] = 'past_event'
    criteria[:order] = {published_at: :desc}
    criteria[:limit] = per_page
    criteria[:offset] = @search_params[:page].present? ? (@search_params[:page].to_i - 1) * per_page : 0

    @documents = Document.search(term, criteria)
  end

  def show
    unless @document.products.present?
      section = @document.sections.find_or_create_by(display_order: 1000)
      @document.create_products(title: 'Products', document_section_id: section.id)
    end
  end

  def new
    @document = Document::PastEvent.new
    render layout: false
  end

  def create
    @document = Document::PastEvent.new(document_params)
    if @document.save
      flash[:notice] = "The page was successfully created"
      return redirect_to admin_past_event_path(@document)
    end
    flash[:error] = "Error creating page: #{@document.errors.full_messages.join('; ')}"
    return redirect_to admin_past_events_path
  end
  
  def admin_page
    'past-events'
  end
end