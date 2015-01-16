require 'test_helper'

class UserTest < ActiveSupport::TestCase #on terminal: $bundle exec rake test:models OR rake test:models
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Mr Celophane", email: "mr@celophane.net")
  end

  test "user is valid" do #this will check if the user's acceptable name & email above pass the validations for the model.
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
    @user.email = "hello,world.com"
    assert_not @user.valid?
  end

  test "user with a very long name is not valid" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "user with a very long email is not valid" do
    @user.email = "a" + "@" + "a" * 249 + ".com"
    assert_not @user.valid?
  end

  test "email address should be unique" do
    duplicate = @user.dup #the '.dup' here is used to copy all the attributes of '@user'; assigning 'duplicate = @user' only would reference to the same object in the computer's memory and would save '@user' twice.
    duplicate.email = @user.email.upcase #checks to see if the same e-mail can be saved again if written in, say, uppercase letters.
    @user.save
    assert_not duplicate.valid?
end
