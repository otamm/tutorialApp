require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  get new_user_path

  assert_no_difference 'User.count' do #arrange for comparison of 'User.count' before and after the block runs.
    post users_path, user: { name:  "",
      email: "user@invalid",
      password:              "foo",
      password_confirmation: "bar" }
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
end
