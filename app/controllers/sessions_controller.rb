class SessionsController < ApplicationController
  def new
    cookies[:session_key] = Session.new_session_key(request.remote_ip) unless cookies[:session_key].present?
    @session = Session.find(cookies[:session_key])
    if @session.is_logged_in?
      return redirect_to (params[:return_to].present? ? params[:return_to] : root_url)
    else
      cookies[:return_to] = params[:return_to].present? ? params[:return_to] : (request.referrer || root_url)
    end
  end
  
  def create
    @session = Session.find(cookies[:session_key])
    @session.user_name = session_params[:user_name]
    if session_params[:user_name].present? && session_params[:password].present?
      @new_session = Session.login(session_params[:user_name], session_params[:password], {session_key: cookies[:session_key]})
      if @new_session.present?
        if (return_to = cookies.delete(:return_to)).present?
          return redirect_to return_to
        end
      else
        @session.errors.add(:base, "There was a problem with your login.")
      end
    else
      @session.errors.add(:user_name, "required") if session_params[:user_name].blank?
      @session.errors.add(:password, "required") if session_params[:password].blank?
    end
    return render :new
  end
  
  def destroy
    Session.logout(cookies[:session_key])
    cookies.delete(:session_key)
    redirect_to root_url
  end
  
  private

  def session_params
    params.require(:session).permit(:user_name, :password)
  end
end
