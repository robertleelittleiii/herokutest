require 'test_helper'

class UserAttributesControllerTest < ActionController::TestCase
  setup do
    @user_attribute = user_attributes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_attributes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_attribute" do
    assert_difference('UserAttribute.count') do
      post :create, :user_attribute => @user_attribute.attributes
    end

    assert_redirected_to user_attribute_path(assigns(:user_attribute))
  end

  test "should show user_attribute" do
    get :show, :id => @user_attribute.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user_attribute.to_param
    assert_response :success
  end

  test "should update user_attribute" do
    put :update, :id => @user_attribute.to_param, :user_attribute => @user_attribute.attributes
    assert_redirected_to user_attribute_path(assigns(:user_attribute))
  end

  test "should destroy user_attribute" do
    assert_difference('UserAttribute.count', -1) do
      delete :destroy, :id => @user_attribute.to_param
    end

    assert_redirected_to user_attributes_path
  end
end
