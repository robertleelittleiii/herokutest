require 'test_helper'

class CustomerActionsControllerTest < ActionController::TestCase
  test "should get order_history" do
    get :order_history
    assert_response :success
  end

end
