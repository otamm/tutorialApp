require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_select "title", "Home" #checks if given HTML tag exists + its content
    assert_response :success # = 200 OK response
  end

  test "should get help" do
    get :help
    assert_select "title", "Help"
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_select "title", "About"
    assert_response :success
  end

end
