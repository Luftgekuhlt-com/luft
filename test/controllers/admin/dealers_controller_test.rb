require 'test_helper'

class Admin::DealersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_dealer = admin_dealers(:one)
  end

  test "should get index" do
    get admin_dealers_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_dealer_url
    assert_response :success
  end

  test "should create admin_dealer" do
    assert_difference('Admin::Dealer.count') do
      post admin_dealers_url, params: { admin_dealer: {  } }
    end

    assert_redirected_to admin_dealer_url(Admin::Dealer.last)
  end

  test "should show admin_dealer" do
    get admin_dealer_url(@admin_dealer)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_dealer_url(@admin_dealer)
    assert_response :success
  end

  test "should update admin_dealer" do
    patch admin_dealer_url(@admin_dealer), params: { admin_dealer: {  } }
    assert_redirected_to admin_dealer_url(@admin_dealer)
  end

  test "should destroy admin_dealer" do
    assert_difference('Admin::Dealer.count', -1) do
      delete admin_dealer_url(@admin_dealer)
    end

    assert_redirected_to admin_dealers_url
  end
end
