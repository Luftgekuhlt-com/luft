class VideosController < ApplicationController

  # GET /categories
  # GET /categories.json
  def index
    @latest =  true unless params[:tag].present? && params[:tag] != "latest"
    @category = Tag.find_by(slug: params[:tag]) if !@latest && params[:tag].present?
    @page_size = (params[:page_size].presence || "4").to_i
    if @latest
      @videos = Video.all.order("published_at desc")
    elsif @category.present? && @category.is_category?
      @videos = Video.items_by_category(params[:tag], @page_size)
    elsif @category.present? && !@category.is_category?
      @videos = Video.items_by_tag(params[:tag], @page_size)
    else
      @featured_videos = Video.items_by_category("featured", @page_size)
      @latest_videos = Video.items_by_category(nil, @page_size, @featured_videos.map(&:id))
      @categories = Video.categories_and_counts
      @tags = Video.tags_and_counts
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
      @video = Video.find_by(slug: params[:id])
  end

  private
end
