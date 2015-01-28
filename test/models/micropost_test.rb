require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:bob)
    @micropost = @user.microposts.build(content: "Lorem ipsum") # ', user_id: @user.id)': no longer necessary, the micropost is already associated with the user. # a micropost is necessarily associated with an user. Note that the method is '.build()' is different from '.create()' because '.build()' returns an object while '.create()' returns and saves to the DB.
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present " do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be from most to least recent" do
    assert_equal Micropost.first, microposts(:most_recent)
  end

end
