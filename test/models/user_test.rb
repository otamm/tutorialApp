require 'test_helper'

class UserTest < ActiveSupport::TestCase #on terminal: $bundle exec rake test:models OR rake test:models
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Mr Celophane", email: "mr@celophane.net")
  end

  test "user is valid" do
    assert @user.valid? #assert: makes sure that its argument (@user.valid?) returns 'true'
  end

  test "user without name is not valid" do
    @user.name = ""
    assert_not @user.valid? #assert_not: makes sure that its argument returns 'false'
  end

  test "user without email is not valid" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "user without proper name is not valid" do
    @user.name = "      "
    assert_not @user.valid?
  end

  test "user without proper email is not valid" do
    @user.email = "hello,world"
    assert_not @user.valid?
  end

  test "user with a very long name is not valid" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "user with a very long email is not valid" do
    @user.email = "a" + "@" + "a" * 252 + ".com"
    assert_not @user.valid?
  end
end
