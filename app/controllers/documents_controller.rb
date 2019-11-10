class DocumentsController < ApplicationController

  def index
    @current_tag = "all"
    if params[:path].present?
      @document = Document.active.find_by(slug: params[:path])
      if @document.present?
        return render :show
      end
      @current_tag = params[:path]
    end
    criteria = {}
    per_page = (params[:per_page] || "100").to_i
    if params[:all].present?
      per_page = 1000
    end
    term = params[:q].presence || "*"
    
    criteria[:fields] = [:search_text]
    criteria[:index_name] = [Rails.env, "pages"].join("_")
    
    criteria[:where] = { }
    criteria[:where][:hidden] = false
    criteria[:where][:archived] = false
    criteria[:where][:page_type] = page_type_filter if page_type_filter.present?
    criteria[:where][:categories] = @current_tag unless @current_tag == "all"
    criteria[:order] = {featured: :desc, published_at: :desc}
    criteria[:limit] = per_page
    criteria[:offset] = params[:page].present? ? (params[:page].to_i - 1) * per_page : 0
    criteria[:aggs] = [:categories]
    @tags = {}
    @pages = Document.search(term, criteria)
    @pages.aggs["categories"]["buckets"].each do |pt|
      @tags[pt["key"]] = pt["doc_count"]
    end
    
  end
  
  def show
    slug = request.path.gsub(/^\//, '')
    @document = Document.active.find_by(slug: slug)
    if @document.present?
      return render :show
    end
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def page_type_filter
    nil
  end

  private
end
