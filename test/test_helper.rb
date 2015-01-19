ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Logs in a test user.
  def log_in_as(user, options = {}) # by default, 'options' will be an empty hash.
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       user.email,
        password:    password,
        remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  private

  def integration_test? # Returns true inside an integration test and false otherwise.
    defined?(post_via_redirect) # 'defined?' is a Rails automatic method.
  end

  # Add more helper methods to be used by all tests here...
  def is_logged_in? # returns true if test user is logged in and false otherwise.
    !session[:user_id].nil?
  end

end
