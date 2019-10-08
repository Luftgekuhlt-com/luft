class AdminController < ApplicationController
  before_action :authenticate_user!
  layout "admin"
  
  helper_method :admin_section
  helper_method :primary_home_spotlight, :secondary_home_spotlight

  def admin_section
    'home'
  end
  
  def primary_home_spotlight
    @primary_home_spotlight ||= begin
      Document::HomeSpotlight.find_by(slug: 'primary_home_spotlight').presence || 
      Document::HomeSpotlight.create(
        slug: 'primary_home_spotlight',
        title: 'Primary Spotlight'
      )
    end
  end
  
  def secondary_home_spotlight
    @secondary_home_spotlight ||= begin
      Document::HomeSpotlight.find_by(slug: 'secondary_home_spotlight').presence || 
      Document::HomeSpotlight.create(
        slug: 'secondary_home_spotlight',
        title: 'Secondary Spotlight'
      )
    end
  end
  
  private
  
end