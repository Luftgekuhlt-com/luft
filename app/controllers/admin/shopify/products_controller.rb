class Admin::Shopify::ProductsController < AdminController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /admin/shopify/products
  # GET /admin/shopify/products.json
  def index
    @products = {}
    ShopifyAPI::CustomCollection.find(:all, limit: 250).each do |collection|
      @products[collection.title] = collection.products
    end
  end

  # GET /admin/shopify/products/1
  # GET /admin/shopify/products/1.json
  def show
  end

  # GET /admin/shopify/products/new
  def new
    @product = Admin::Shopify::Product.new
  end

  # GET /admin/shopify/products/1/edit
  def edit
  end

  # POST /admin/shopify/products
  # POST /admin/shopify/products.json
  def create
    @product = Admin::Shopify::Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/shopify/products/1
  # PATCH/PUT /admin/shopify/products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shopify/products/1
  # DELETE /admin/shopify/products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = ShopifyAPI::Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.fetch(:product, {})
    end
end
