require 'test_helper'

class ReviewerControllerTest < ActionDispatch::IntegrationTest
  test "should get user_id:integer" do
    get reviewer_user_id:integer_url
    assert_response :success
  end

  test "should get department_id:integer" do
    get reviewer_department_id:integer_url
    assert_response :success
  end

  test "should get post_id:integer" do
    get reviewer_post_id:integer_url
    assert_response :success
  end

  test "should get status:integer" do
    get reviewer_status:integer_url
    assert_response :success
  end

  test "should get feedback:text" do
    get reviewer_feedback:text_url
    assert_response :success
  end

end
