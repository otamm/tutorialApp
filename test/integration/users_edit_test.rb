require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob) # the 'bob' fixture.
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {name: "", email: "invalid", password: "aaa", password_confirmation: "ccc" }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Hellow Zees"
    email = "aaa@gsnail.net"
    patch user_path(@user), user: {name: name, email: email, password: "", password_confirmation: "" } # no obligation to change the password or anything.
    assert_not flash.empty?
    @user.reload # reloads the @user object with the current info in the database.
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

end
