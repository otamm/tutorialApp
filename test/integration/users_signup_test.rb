require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  #get '/signup'

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

  test "legitimate signup saves user to db & renders user page" do
    get signup_path
    user = {
      name: "Akshovsky Johnson",
      email: "akj_swag@bol.com",
      password: "h4ck3d",
      password_confirmation: "h4ck3d"
    }
    assert_difference 'User.count' do
      post users_path, user: {
        name: "Akshovsky Johnson",
        email: "akj_swag@bol.com",
        password: "h4ck3d",
        password_confirmation: "h4ck3d"
      }
    end
      user = User.find_by(email: "akj_swag@bol.com")
      get '/users/' + user.id.to_s
      assert_template 'users/show'
      assert is_logged_in? # defined on '/test/test_helper.rb'
  end

end
