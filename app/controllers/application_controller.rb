class ApplicationController < ActionController::Base
  include TicketHelper
  protect_from_forgery with: :exception
  
  
  helper_method :iphone?
  helper_method :android?
  helper_method :mobile?
  helper_method :body_classes, :content_areas, :content_area
  
  
  def body_classes
    @body_classes ||= []
    @body_classes << "#{browser.name}_#{browser.version}".downcase
    @body_classes << "#{browser.to_s}"
    @body_classes << "msie" if request.user_agent.present? && request.user_agent.include?("Edge/")
    @body_classes << "mobile" if browser.device.mobile?
    @body_classes << params[:controller].parameterize if params[:controller].present?
    @body_classes << params[:action] if params[:action].present?
    @body_classes << I18n.locale
    @body_classes << "status-#{response.status}"
    @body_classes << @document.page_type if @document.present?

    @body_classes.join(" ")
  end
  
  def mobile?
    params[:is_mobile].present? || (iphone? || android?)
  end

  def iphone?
    request.user_agent =~ /iphone/i
  end

  def android?
    request.user_agent =~ /android/i
  end
  
  def content_areas
    @content_areas ||= Document.find_or_create_by(slug: "content-areas", type: "Document::ContentAreas", title: "Content Areas")
  end
  
  def content_area(key=nil)
      return nil if key.nil? || content_areas.nil?
      @content_areas.sections.where(title: key).first rescue nil
  end
  
  helper_method :current_session
	
	def current_session
	    @current_session ||= begin
	        cookies[:session_key] = Session.new_session_key(request.remote_ip) unless cookies[:session_key].present?
            session = Session.find(cookies[:session_key])
            session.session_key = cookies[:session_key]
            session
            rescue
            cookies[:session_key] = Session.new_session_key(request.remote_ip)
            session = Session.find(cookies[:session_key])
            session.session_key = cookies[:session_key]
            session
        end
	end
  
end
