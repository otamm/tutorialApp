require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # to run only this integration test, type 'bundle exec rake test TEST=test/integration/users_login_test.rb' in terminal in this app's directory.

  test "login with invalid info (email)" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "ayedonotexist@nonono.net", password: "h4ck3d" }
    assert_template 'sessions/new'
    assert flash.now[:danger] == "Wops! The email ayedonotexist@nonono.net is not registered."
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

end
