require 'test_helper'

class RightsControllerTest < ActionController::TestCase
  setup do
    @right = rights(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rights)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create right" do
    assert_difference('Right.count') do
      post :create, :right => @right.attributes
    end

    assert_redirected_to right_path(assigns(:right))
  end

  test "should show right" do
    get :show, :id => @right.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @right.to_param
    assert_response :success
  end

  test "should update right" do
    put :update, :id => @right.to_param, :right => @right.attributes
    assert_redirected_to right_path(assigns(:right))
  end

  test "should destroy right" do
    assert_difference('Right.count', -1) do
      delete :destroy, :id => @right.to_param
    end

    assert_redirected_to rights_path
  end
end
