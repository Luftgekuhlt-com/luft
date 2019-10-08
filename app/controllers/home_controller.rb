class HomeController < ApplicationController
  def index
    @home_slides = HomeSlide.where("hidden = ? AND start_date <= ? AND end_date >= ?", false, Time.now, Time.now).order(:display_order)
    @primary_portals = HomePortal.visible.primary.limit(6).order(:display_order)
    @primary_spotlight = Document::HomeSpotlight.find_by(slug: 'primary_home_spotlight')
    @secondary_portals = HomePortal.visible.secondary.limit(4).order(:display_order)
    @secondary_spotlight = Document::HomeSpotlight.find_by(slug: 'secondary_home_spotlight')
  end
end