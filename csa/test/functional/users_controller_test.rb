require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @user_details = user_details(:one)
  end

  test "should get index" do
    get :index, {},  {'user_id' => "#{@user_details.id}" }
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new, {}, {'user_id' => "#{@user_details.id}" }
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, { user: { email: 's'+@user.email, firstname: @user.firstname, grad_year: @user.grad_year, jobs: @user.jobs, phone: @user.phone, surname: @user.surname } }, { 'user_id' => "#{@user_details.id}" }
    end

    assert_redirected_to "#{user_path(assigns(:user))}?page=1"
  end

  test "should show user" do
    get :show, { id: @user }, {'user_id' => "#{@user_details.id}" }
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @user},  {'user_id' => "#{@user_details.id}" } 
    assert_response :success
  end

  test "should update user" do
    put :update, {id: @user, user: { email: @user.email, firstname: @user.firstname, grad_year: @user.grad_year, jobs: @user.jobs, phone: @user.phone, surname: @user.surname }},  {'user_id' => "#{@user_details.id}" }
    assert_redirected_to "#{user_path(assigns(:user))}?page=1"
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, {id: @user}, {'user_id' => "#{@user_details.id}" }
    end

    assert_redirected_to "#{users_path}?page=1"
  end
end
