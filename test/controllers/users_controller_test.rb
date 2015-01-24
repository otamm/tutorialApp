require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:bob)
    @other_user = users(:archer)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to(login_url)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update request when logged in as wrong user" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email } # <HTTP method> :controller_action, :id_of_object_of_action, <data to be sent (if request == POST or PATCH)>
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy request when logged in as a non-admin user" do
    log_in_as(@other_user) # non-admin user
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test "should destroy user when requested by admin" do
    @some_other_user = User.new(name: "I'm some dummy user born to be killed", email: "mr_suicide@tumblr.com", password: "h4ck3d", password_confimation: "h4cked")
    @some_other_user.save
    log_in_as(@user) #admin user
    assert_difference 'User.count', -1 do
      delete :destroy, id: @some_other_user
    end
    assert flash.now[:success] == "User deleted."
    assert_redirected_to users_url
  end

end
