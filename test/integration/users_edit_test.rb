require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:bob) # the 'bob' fixture.
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_redirected_to edit_user_url
    patch user_path(@user), user: {name: "", email: "invalid", password: "aaa", password_confirmation: "ccc" }
    assert_redirected_to sessions_new_url
  end

  test "successful edit with friendly forwarding" do # redirects user to page s/he clicked when signed out after logging in.
    get edit_user_url(@user) # loads edit page while signed out.
    assert_redirected_to new_session_url
    log_in_as(@user) # logs into account.
    assert_redirected_to edit_user_url # now, the previously visited page is opened.
    name = "Hellow Zees"
    email = "aaa@gsnail.net"
    patch user_path(@user), user: {name: name, email: email, password: "", password_confirmation: "" } # no obligation to change the password or anything.
    assert_not flash.empty?
    @user.reload # reloads the @user object with the current info in the database.
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

end
