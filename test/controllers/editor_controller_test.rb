require 'test_helper'

class EditorControllerTest < ActionDispatch::IntegrationTest
  test "should get user_id:integer" do
    get editor_user_id:integer_url
    assert_response :success
  end

  test "should get department_id:integer" do
    get editor_department_id:integer_url
    assert_response :success
  end

  test "should get post_id:integer" do
    get editor_post_id:integer_url
    assert_response :success
  end

  test "should get status" do
    get editor_status_url
    assert_response :success
  end

  test "should get comment:text" do
    get editor_comment:text_url
    assert_response :success
  end

end
