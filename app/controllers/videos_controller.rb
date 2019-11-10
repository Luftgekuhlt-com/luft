class VideosController < ApplicationController

  def index
    @videos = Video.all.order("published_at desc")
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
      @video = Video.find_by(slug: params[:id])
  end

  private
end
