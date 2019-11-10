class GalleriesController < DocumentsController
  def page_type_filter
    'gallery'
  end
  
  def show
    @document = Document.active.find_by(slug: params[:slug])
    if @document.present?
      return render :show
    end
    raise ActionController::RoutingError.new('Not Found')
  end

  private
end
