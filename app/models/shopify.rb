class Shopify
  def self.shop
    @shop ||= ShopifyAPI::Shop.current
  end
end