require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:bob)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    log_in_as(@user)
    assert is_logged_in?
    assert_equal @user, current_user
  end

  test "current_user returns nil when remember digest is wrong" do
    log_in_as(@user)
    assert_not_nil current_user
    @user.update_attribute(:remember_digest, "HELLO") #User.digest(User.new_token))
    assert_nil current_user
  end
end
