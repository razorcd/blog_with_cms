require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get register_form" do
    get :register_form
    assert_response :success
  end

  test "should get login_form" do
    get :login_form
    assert_response :success
  end

  test "should get edit_form" do
    get :edit_form
    assert_response :success
  end

end
