require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase

  def setup
    @micropost = microposts(:useless) # defined on fixtures/microposts.yml
  end

  test "should redirect 'create' when user is not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: "HELLOOOO" }
    end
    assert_redirected_to login_url
  end

  test "should redirect 'destroy' when user is not logged in" do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:bob)) # not even the admin could delete posts.
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end

end
