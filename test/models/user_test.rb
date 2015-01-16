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

  test "user is not valid" do
    @user.name = "     "
    assert_not @user.valid? #assert_not: makes sure that its argument returns 'false'
  end

  test "user is not valid" do
    @user.email = "hello,world"
    assert_not @user.valid?
  end
end
