class Admin::Shopify::OrdersController < AdminController
  protect_from_forgery :except => [:update, :delete, :create]
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, :only => [:create]
  # GET /admin/shopify/orders
  # GET /admin/shopify/orders.json
  def index
    @orders = ShopifyAPI::Order.find(:all, status: "any")
  end

  # GET /admin/shopify/orders/1
  # GET /admin/shopify/orders/1.json
  def show
  end

  # GET /admin/shopify/orders/new
  def new
  end

  # GET /admin/shopify/orders/1/edit
  def edit
  end

  # POST /admin/shopify/orders
  # POST /admin/shopify/orders.json
  def create
    shopify_order = params[:order]
    SyncLog.create(additional_info: shopify_order)
    qb_order = ::Quickbooks::SalesReceipt.from_shopify_order(shopify_order)
    qb_order_data = QuickbooksAccess.to_qb_hash(qb_order)
    puts "qb_order_data: #{qb_order_data.inspect}"
    order_resp = QuickbooksAccess.client.create(:salesreceipt, payload: qb_order_data)
    SyncLog.create(additional_info: {req: qb_order_data, resp: order_resp})
    render status: 200, json: shopify_order.to_json
  end

  # PATCH/PUT /admin/shopify/orders/1
  # PATCH/PUT /admin/shopify/orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shopify/orders/1
  # DELETE /admin/shopify/orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Product was successfully destroyed.' }
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
