require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  #get '/signup'

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
        email: "user@invalid",
        password:              "foo",
        password_confirmation: "bar" }
    end
      assert_template 'users/new'
  end

  test "legitimate signup with account activation saves user to db & renders user page" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, user: {
        name: "Akshovsky Johnson",
        email: "akj_swag@bol.com",
        password: "h4ck3d",
        password_confirmation: "h4ck3d"
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size # this code verifies that exactly 1 e-mail was delivered.
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in? # defined on '/test/test_helper.rb'
  end

end
