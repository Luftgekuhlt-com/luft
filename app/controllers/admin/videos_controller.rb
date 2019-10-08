class Admin::VideosController < AdminController
  before_action :set_video, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @videos = Video.all.order("published_at desc")
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @video = Video.new
    @video.published_at = Date.today
    render layout: false
  end

  # GET /categories/1/edit
  def edit
    render layout: false
  end

  # POST /categories
  # POST /categories.json
  def create
    @video = Video.new(video_params)
    if params[:slim].present?
      slim_current = JSON.parse(params[:slim].first) rescue {}
      slim_new = JSON.parse(params[:slim].last) rescue {}
      slim = slim_new["actions"].present? ? slim_new : slim_current
      if slim["actions"].present?  && @video.crop_actions != slim["actions"]
        @video.crop_actions = slim["actions"]
        @video.reprocess_thumb_image = true
      end
      if slim["input"].present? && slim["input"]["image"].present?
        img = Paperclip.io_adapters.for(slim["input"]["image"])
        img.original_filename = slim["input"]["name"]

        @video.thumb_image = img
      end
    end
    if @video.save
      flash[:notice] = "The video was successfully created"
    end
    return redirect_to admin_videos_path
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
   @video.attributes = video_params
    if params[:slim].present?
      slim_current = JSON.parse(params[:slim].first) rescue {}
      slim_new = JSON.parse(params[:slim].last) rescue {}
      slim = slim_new["actions"].present? ? slim_new : slim_current
      if slim["actions"].present?  && @video.crop_actions != slim["actions"]
        @video.crop_actions = slim["actions"]
        @video.reprocess_thumb_image = true
      end
      if slim["input"].present? && slim["input"]["image"].present?
        img = Paperclip.io_adapters.for(slim["input"]["image"])
        img.original_filename = slim["input"]["name"]

        @video.thumb_image = img
      end
    end
    if @video.save
      
      flash[:notice] = "The video was successfully updated"
    end
    return redirect_to admin_videos_path
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    if @video.destroy
      flash[:notice] = "The video was successfully deleted"
    end
  end
  
  def add_video_tag
    if params[:tag].present?
      @tag = Tag.new(name: params[:tag])
      if @tag.save
        @tag_result = {success: true, tag: @tag}
      else
        @tag_result = {success: false, reason: @tag.errors.full_messages}
      end
    else
      @tag_result = {success: false, reason: "no tag passed"}
    end
    respond_to do |format|
      format.json { render(json: @tag_result) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.fetch(:video, {}).permit!
    end
end
