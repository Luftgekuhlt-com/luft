class Admin::HomeSlidesController < AdminController
  include Amazon::S3
  before_action :set_slide, only: [:show, :edit, :update, :destroy, :move]

  # GET /categories
  # GET /categories.json
  def index
    @slides = HomeSlide.all.order(:display_order)
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @slide = HomeSlide.new
    @slide.end_date = 1.year.from_now
  end

  # GET /categories/1/edit
  def edit
    @slide.preview_image_url = @slide.main_image.url if @slide.main_image.present?
  end

  # POST /categories
  # POST /categories.json
  def create
    @slide = HomeSlide.new(home_slide_params)
    if params[:slim].present?
      slim_current = JSON.parse(params[:slim].first) rescue {}
      slim_new = JSON.parse(params[:slim].last) rescue {}
      slim = slim_new["actions"].present? ? slim_new : slim_current
      if slim["actions"].present?  && @slide.crop_actions != slim["actions"]
        @slide.crop_actions = slim["actions"]
        @slide.reprocess_main_image = true
      end
      if slim["input"].present? && slim["input"]["image"].present?
        img = Paperclip.io_adapters.for(slim["input"]["image"])
        img.original_filename = slim["input"]["name"]

        @slide.main_image = img
      end
    end
    if @slide.save
      flash[:notice] = "The slide was successfully created"
    end
    return redirect_to admin_home_slides_path
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    @slide.attributes = home_slide_params
    if params[:slim].present?
      params[:slim].each do |slim|
        next if slim.blank?
        slim_data = JSON.parse(slim) rescue nil
        unless slim_data.nil?
          if slim_data["meta"].present? && slim_data["meta"]["type"] == "mobile"
            if slim_data["actions"].present?  && @slide.crop_actions != slim_data["actions"]
              @slide.mobile_crop_actions = slim_data["actions"]
              @slide.reprocess_mobile_image = true
            end
            if slim_data["input"].present? && slim_data["input"]["image"].present?
              img = Paperclip.io_adapters.for(slim_data["input"]["image"])
              img.original_filename = slim_data["input"]["name"]
      
              @slide.mobile_image = img
            end
          else
            if slim_data["actions"].present?  && @slide.crop_actions != slim_data["actions"]
              @slide.crop_actions = slim_data["actions"]
              @slide.reprocess_main_image = true
            end
            if slim_data["input"].present? && slim_data["input"]["image"].present?
              img = Paperclip.io_adapters.for(slim_data["input"]["image"])
              img.original_filename = slim_data["input"]["name"]
      
              @slide.main_image = img
            end
          end
        end
      end
    end
    if @slide.save
      
      flash[:notice] = "The slide was successfully updated"
    end
    return redirect_to admin_home_slides_path
  end
  
  def move
    if params[:direction].present?
      curr_disp_order = @slide.display_order
      if params[:direction] == "down"
        other_slide = HomeSlide.where("display_order > ?", curr_disp_order).order("display_order asc").first
        if other_slide.present?
          @slide.display_order = other_slide.display_order
          other_slide.display_order = curr_disp_order
          @slide.save
          other_slide.save
        end
      else
        other_slide = HomeSlide.where("display_order < ?", curr_disp_order).order("display_order desc").first
        if other_slide.present?
          @slide.display_order = other_slide.display_order
          other_slide.display_order = curr_disp_order
          @slide.save
          other_slide.save
        end
      end
    end
    redirect_to admin_home_slides_path
  end
  
  def preview
    @slide = HomeSlide.find(params[:slide_id]) if params[:slide_id].present?
    unless @slide.present?
      @slide = HomeSlide.new
      @slide.attributes = home_slide_params
      @slide.id = Time.now.to_i
      if params[:slim].present?
        slim_current = JSON.parse(params[:slim].first) rescue {}
        slim_new = JSON.parse(params[:slim].last) rescue {}
        slim = slim_new["actions"].present? ? slim_new : slim_current
        if slim["actions"].present?  && @slide.crop_actions != slim["actions"]
          @slide.crop_actions = slim["actions"]
          @slide.reprocess_main_image = true
        end
        if slim["output"].present? && slim["output"]["image"].present?
          img = Paperclip.io_adapters.for(slim["output"]["image"])
          img.original_filename = slim["output"]["name"]
          file_ext = img.original_filename.split(".").last
          path = "home_slides/previews/#{img.original_filename[0]}-#{rand(5000)}.#{file_ext}"
      
          s3_object = s3_bucket.object(path)
          s3_object.put(body: img, acl: "public-read")
          @slide.preview_image_url = s3_object.public_url
        end
      end
    end
    render layout: 'admin_blank'
  end
  
  def preview_upload
     @image_url = ""
    if params[:slim].present?
      slim = params[:slim]
      if slim[:output].present? && slim[:output][:image].present?
        img = Paperclip.io_adapters.for(slim[:output][:image])
        img.original_filename = slim[:output][:name]
        file_ext = img.original_filename.split(".").last
        path = "home_slides/#{params[:mobile].present? ? "mobile-" : ""}preview.#{file_ext}"
    
        s3_object = s3_bucket.object(path)
        s3_object.put(body: img, acl: "public-read")
        @image_url = s3_object.public_url
      end
    end
    respond_to do |format|
      format.json { render(json: {success: !@image_url.blank?, image_url: @image_url, reason: @image_url.blank? ? "no slim" : ""}) }
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    if @slide.destroy
      flash[:notice] = "The slide was successfully deleted"
    end
  end
  
  def add_slide_tag
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
    def set_slide
      @slide = HomeSlide.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def home_slide_params
      params.fetch(:home_slide, {}).permit!
    end
end
