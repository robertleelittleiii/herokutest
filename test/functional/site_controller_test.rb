require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test "should get index.html" do
    get :index.html
    assert_response :success
  end

end
