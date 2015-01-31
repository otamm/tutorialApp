require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest

  include ApplicationHelper # the 'full_title' method is defined here.

  def setup
    @user = users(:bob)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', @user.name
    assert_select 'h1', text: @user.name # test for an h1 tag which has the name of the @user as text content inside.
    assert_select 'h1>img.gravatar' # this checks for an img tag with class 'gravatar' nested inside an h1 tag.
    assert_match @user.microposts.count.to_s, response.body # response.body returns the whole HTML of the page, not just the body; this line of code tests wheter or not the number of microposts posted by that user appears on the page.
    assert_select 'div.pagination' # checks for a div with class 'pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

end
