class Admin::Shopify::CartsController < AdminController
  protect_from_forgery :except => [:update, :delete, :create]
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, :only => [:create, :update]
  # GET /admin/shopify/carts
  # GET /admin/shopify/carts.json
  def index
    @carts = ShopifyAPI::Order.find(:all, status: "any")
  end

  # GET /admin/shopify/carts/1
  # GET /admin/shopify/carts/1.json
  def show
  end

  # GET /admin/shopify/carts/new
  def new
  end

  # GET /admin/shopify/carts/1/edit
  def edit
  end

  # POST /admin/shopify/carts
  # POST /admin/shopify/carts.json
  def create
    SyncLog.create(additional_info: params)
    render status: 200, json: params.to_json
  end

  # PATCH/PUT /admin/shopify/carts/1
  # PATCH/PUT /admin/shopify/carts/1.json
  def update
    cart = params["cart"]
    SyncLog.create(additional_info: cart)
    render status: 200, json: cart.to_json
  end

  # DELETE /admin/shopify/carts/1
  # DELETE /admin/shopify/carts/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = ShopifyAPI::Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.fetch(:order, {})
    end
end
