require 'test_helper'

class RegistrationControllerTest < ActionController::TestCase
  test "should get register" do
    get :register
    assert_response :success
  end

  test "should get unregister" do
    get :unregister
    assert_response :success
  end

end
