require 'test_helper'

class Admin::Shopify::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_shopify_product = admin_shopify_products(:one)
  end

  test "should get index" do
    get admin_shopify_products_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_shopify_product_url
    assert_response :success
  end

  test "should create admin_shopify_product" do
    assert_difference('Admin::Shopify::Product.count') do
      post admin_shopify_products_url, params: { admin_shopify_product: {  } }
    end

    assert_redirected_to admin_shopify_product_url(Admin::Shopify::Product.last)
  end

  test "should show admin_shopify_product" do
    get admin_shopify_product_url(@admin_shopify_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_shopify_product_url(@admin_shopify_product)
    assert_response :success
  end

  test "should update admin_shopify_product" do
    patch admin_shopify_product_url(@admin_shopify_product), params: { admin_shopify_product: {  } }
    assert_redirected_to admin_shopify_product_url(@admin_shopify_product)
  end

  test "should destroy admin_shopify_product" do
    assert_difference('Admin::Shopify::Product.count', -1) do
      delete admin_shopify_product_url(@admin_shopify_product)
    end

    assert_redirected_to admin_shopify_products_url
  end
end
