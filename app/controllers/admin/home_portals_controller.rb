class Admin::HomePortalsController < AdminController
  include Amazon::S3
  before_action :set_portal, only: [:show, :edit, :update, :destroy, :move]

  # GET /categories
  # GET /categories.json
  def index
    @portals = HomePortal.where(category: params[:category]).order(:display_order)
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @portal = HomePortal.new
    @portal.start_date = Date.today
    @portal.end_date = 1.year.from_now.to_date
    @portal.category = params[:category] || 'primary'
  end

  # GET /categories/1/edit
  def edit
    @portal.preview_image_url = @portal.main_image.url if @portal.main_image.present?
  end

  # POST /categories
  # POST /categories.json
  def create
    @portal = HomePortal.new(home_portal_params)
     if params[:slim].present?
      params[:slim].each do |slim|
        next if slim.blank?
        slim_data = JSON.parse(slim) rescue nil
        unless slim_data.nil?
          if slim_data["meta"].present? && slim_data["meta"]["type"] == "mobile"
            if slim_data["actions"].present?  && @portal.crop_actions != slim_data["actions"]
              @portal.mobile_crop_actions = slim_data["actions"]
              @portal.reprocess_mobile_image = true
            end
            if slim_data["input"].present? && slim_data["input"]["image"].present?
              img = Paperclip.io_adapters.for(slim_data["input"]["image"])
              img.original_filename = slim_data["input"]["name"]
      
              @portal.mobile_image = img
            end
          else
            if slim_data["actions"].present?  && @portal.crop_actions != slim_data["actions"]
              @portal.crop_actions = slim_data["actions"]
              @portal.reprocess_main_image = true
            end
            if slim_data["input"].present? && slim_data["input"]["image"].present?
              img = Paperclip.io_adapters.for(slim_data["input"]["image"])
              img.original_filename = slim_data["input"]["name"]
      
              @portal.main_image = img
            end
          end
        end
      end
    end
    if @portal.save
      flash[:notice] = "The portal was successfully created"
    end
    return redirect_to admin_home_portals_path(category: @portal.category)
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    @portal.attributes = home_portal_params
    if params[:slim].present?
      params[:slim].each do |slim|
        next if slim.blank?
        slim_data = JSON.parse(slim) rescue nil
        unless slim_data.nil?
          if slim_data["meta"].present? && slim_data["meta"]["type"] == "mobile"
            if slim_data["actions"].present?  && @portal.crop_actions != slim_data["actions"]
              @portal.mobile_crop_actions = slim_data["actions"]
              @portal.reprocess_mobile_image = true
            end
            if slim_data["input"].present? && slim_data["input"]["image"].present?
              img = Paperclip.io_adapters.for(slim_data["input"]["image"])
              img.original_filename = slim_data["input"]["name"]
      
              @portal.mobile_image = img
            end
          else
            if slim_data["actions"].present?  && @portal.crop_actions != slim_data["actions"]
              @portal.crop_actions = slim_data["actions"]
              @portal.reprocess_main_image = true
            end
            if slim_data["input"].present? && slim_data["input"]["image"].present?
              img = Paperclip.io_adapters.for(slim_data["input"]["image"])
              img.original_filename = slim_data["input"]["name"]
      
              @portal.main_image = img
            end
          end
        end
      end
    end
    if @portal.save
      
      flash[:notice] = "The portal was successfully updated"
    end
    return redirect_to admin_home_portals_path(category: @portal.category)
  end
  
  def move
    if params[:direction].present?
      curr_disp_order = @portal.display_order
      if params[:direction] == "down"
        other_portal = HomePortal.where("display_order > ?", curr_disp_order).order("display_order asc").first
        if other_portal.present?
          @portal.display_order = other_portal.display_order
          other_portal.display_order = curr_disp_order
          @portal.save
          other_portal.save
        end
      else
        other_portal = HomePortal.where("display_order < ?", curr_disp_order).order("display_order desc").first
        if other_portal.present?
          @portal.display_order = other_portal.display_order
          other_portal.display_order = curr_disp_order
          @portal.save
          other_portal.save
        end
      end
    end
    redirect_to admin_home_portals_path(category: @portal.category)
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    category = @portal.category
    if @portal.destroy
      flash[:notice] = "The portal was successfully deleted"
    end
    redirect_to admin_home_portals_path(category: category)
  end
  
  def preview
    @portal = HomeSlide.find(params[:portal_id]) if params[:portal_id].present?
    unless @portal.present?
      @portal = HomeSlide.new
      @portal.attributes = home_portal_params
      @portal.id = Time.now.to_i
      if params[:slim].present?
        slim_current = JSON.parse(params[:slim].first) rescue {}
        slim_new = JSON.parse(params[:slim].last) rescue {}
        slim = slim_new["actions"].present? ? slim_new : slim_current
        if slim["actions"].present?  && @portal.crop_actions != slim["actions"]
          @portal.crop_actions = slim["actions"]
          @portal.reprocess_main_image = true
        end
        if slim["output"].present? && slim["output"]["image"].present?
          img = Paperclip.io_adapters.for(slim["output"]["image"])
          img.original_filename = slim["output"]["name"]
          file_ext = img.original_filename.split(".").last
          path = "home_portals/previews/#{img.original_filename[0]}-#{rand(5000)}.#{file_ext}"
      
          s3_object = s3_bucket.object(path)
          s3_object.put(body: img, acl: "public-read")
          @portal.preview_image_url = s3_object.public_url
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
        path = "home_portals/#{params[:mobile].present? ? "mobile-" : ""}preview.#{file_ext}"
    
        s3_object = s3_bucket.object(path)
        s3_object.put(body: img, acl: "public-read")
        @image_url = s3_object.public_url
      end
    end
    respond_to do |format|
      format.json { render(json: {success: !@image_url.blank?, image_url: @image_url, reason: @image_url.blank? ? "no slim" : ""}) }
    end
  end
  
  def add_portal_tag
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
    def set_portal
      @portal = HomePortal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def home_portal_params
      params.fetch(:home_portal, {}).permit!
    end
end
