require 'test_helper'

class DocumentPartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @document_part = document_parts(:one)
  end

  test "should get index" do
    get document_parts_url
    assert_response :success
  end

  test "should get new" do
    get new_document_part_url
    assert_response :success
  end

  test "should create document_part" do
    assert_difference('DocumentPart.count') do
      post document_parts_url, params: { document_part: {  } }
    end

    assert_redirected_to document_part_url(DocumentPart.last)
  end

  test "should show document_part" do
    get document_part_url(@document_part)
    assert_response :success
  end

  test "should get edit" do
    get edit_document_part_url(@document_part)
    assert_response :success
  end

  test "should update document_part" do
    patch document_part_url(@document_part), params: { document_part: {  } }
    assert_redirected_to document_part_url(@document_part)
  end

  test "should destroy document_part" do
    assert_difference('DocumentPart.count', -1) do
      delete document_part_url(@document_part)
    end

    assert_redirected_to document_parts_url
  end
end
