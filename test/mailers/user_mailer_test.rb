require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:bob)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@veryveryverycoolwebsite.net"], mail.from
    assert_match "Hi " + user.name, mail.body.encoded # assert_match can be used either with a string or RegEx.
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded # CGI::escape() is (almost) equivalent to URI.escape, but the latter was depreciated on ruby 1.9.2
  end

  test "password_reset" do
    user = users(:bob)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@veryveryverycoolwebsite.net"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI::escape(user.email), mail.body.encoded
  end

end
