require 'test_helper'

class UserTest < ActiveSupport::TestCase #on terminal: $bundle exec rake test:models OR rake test:models
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(name: "Mr Celophane", email: "mr@celophane.net", password: "h4ck3d", password_confirmation: "h4ck3d") #both password attributes are only useful in a sign up form,as the hashed password is saved with the user.
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
    @user.email = "a" * 250 + "@" + "aaaaa.com"
    assert_not @user.valid?
  end

  test "email address should be unique" do
    duplicate = @user.dup #the '.dup' here is used to copy all the attributes of '@user'; assigning 'duplicate = @user' only would reference to the same object in the computer's memory and would save '@user' twice.
    duplicate.email = @user.email.upcase #checks to see if the same e-mail can be saved again if written in, say, uppercase letters.
    @user.save
    assert_not duplicate.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5 #assigned two variables at the same time here.
    assert_not @user.valid?
  end

  test "password should have a maximum length" do
    @user.password = @user.password_confirmation = "a" * 17
    assert_not @user.valid?
  end

  test "password and its confirmation should match" do
    @user.password = "pwn3d"
    @user.password_confirmation = "f41l_pwn3d"
    assert_not @user.valid?
  end

  test ".authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?("remember", '')
  end

  test "associated microposts should be destroyed with user" do
    @user.save
    @user.microposts.create!(content: "HELLO ===DDDD")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
