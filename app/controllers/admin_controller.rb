class AdminController < ApplicationController
  before_action :authenticate_user!
  layout "admin"
  
  helper_method :admin_section, :admin_page

  def admin_section
    'home'
  end
  
  def admin_page
    'home'
  end

  private
  
end