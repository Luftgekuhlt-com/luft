require 'test_helper'

class DocumentPartImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @document_part_image = document_part_images(:one)
  end

  test "should get index" do
    get document_part_images_url
    assert_response :success
  end

  test "should get new" do
    get new_document_part_image_url
    assert_response :success
  end

  test "should create document_part_image" do
    assert_difference('DocumentPartImage.count') do
      post document_part_images_url, params: { document_part_image: {  } }
    end

    assert_redirected_to document_part_image_url(DocumentPartImage.last)
  end

  test "should show document_part_image" do
    get document_part_image_url(@document_part_image)
    assert_response :success
  end

  test "should get edit" do
    get edit_document_part_image_url(@document_part_image)
    assert_response :success
  end

  test "should update document_part_image" do
    patch document_part_image_url(@document_part_image), params: { document_part_image: {  } }
    assert_redirected_to document_part_image_url(@document_part_image)
  end

  test "should destroy document_part_image" do
    assert_difference('DocumentPartImage.count', -1) do
      delete document_part_image_url(@document_part_image)
    end

    assert_redirected_to document_part_images_url
  end
end
