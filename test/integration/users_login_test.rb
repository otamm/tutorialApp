require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # to run only this integration test, type 'bundle exec rake test TEST=test/integration/users_login_test.rb' in terminal in this app's directory.

  def setup
    @user = users(:bob) # 'users' here is defined on /test/fixtures/users.yml
  end
  test "login with invalid info (email)" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "ayedonotexist@nonono.net", password: "h4ck3d" }
    assert_template 'sessions/new'
    assert flash.now[:danger] == "Wops! The email ayedonotexist@nonono.net is not registered." # the '.now' after 'flash[]' makes the 'flash[]' be active only until the next HTTP request is sent.
    get root_path
    assert flash.empty? #tests if flash[:alert] is active for only one HTTP request.
  end

  test "login with invalid info (password)" do
    get login_path
    assert_template 'sessions/new'
    total_users = User.all.count
    valid_user = User.new(name: "I'm Valid", email: "thisisvalid@bol.net", password: "alsovalid", password_confirmation: "alsovalid")
    valid_user.save #creates a record for valid_user in the Test environment db.
    post login_path, session: { email: valid_user.email, password: "wopswrongpassword" }
    assert_template 'sessions/new'
    assert flash.now[:danger] == "Wops! Wrong password!"
    valid_user.destroy
    assert total_users == User.all.count #checks if 'valid_user' was deleted from db.
    get root_path
    assert flash.empty? #tests if flash[:alert] is active for only one HTTP request.
  end

  test "login with valid info and then logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'h4ck3d' } # 'h4ck3d' == bob's legitimate password.
    assert_redirected_to @user # assert the right redirect target.
    follow_redirect! # loads the page redirected.
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0 # verify that login link disappear by verifying there are 0 login paths on the page (should be replaced by 'sign out')
    assert_select "a[href=?]", logout_path # verify that 'logout' link is actually displayed.
    assert_select "a[href=?]", user_path(@user) # verify that a link to the logged user's profile page is displayed.
  # the terminal command below is used to run this specific test of this specific file.
  # (1st chmod) $ bundle exec rake test TEST=test/integration/users_login_test.rb \
  # (2nd chmod) >  TESTOPTS="--name test_login_with_valid_information"
    delete logout_path # 'delete' is the HTTP method.
    assert_redirected_to root_url
    delete logout_path # simulates the 'logout' button being pressed by an already logged out user.
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end

  test ".authenticated? should return false for a user with a nil token digest" do
    assert_not @user.authenticated?('remember','')
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token'] # inside tests, 'cookies[]' only accepts strings as keys (don't know why)
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end

end
