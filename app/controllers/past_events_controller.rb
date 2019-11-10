class PastEventsController < DocumentsController
  def page_type_filter
    'past_event'
  end
  
  def storyline
    @document = Document.active.find_by(slug: params[:slug])
    raise ActionController::RoutingError.new('Not Found') if @document.blank?
  end

  private
end
