class User < ActiveRecord::Base
  attr_accessor :remember_token
  attr_accessible :name, :email, :password, :password_confirmation, :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #constant for the RegEx that validates the e-mail; more info on README.md
  has_secure_password #method used with bcrypt gem, which uses cryptographic hash functions before storing a password (http://en.wikipedia.org/wiki/Hash_function)

  # on a 'rails console --sandbox', if 'user.valid? == false' use 'user.errors.full_messages' to check for the specific error message.
  validates(:name, presence: true, length: {maximum: 50}) # comments on each argument are below.
  #(presence:true): equivalent to "user.save if user.name.size > 0" in logic, the 'validates()' method also add errors to the screen according to the argument passed ('name can't be blank') for (:name,presence: true)
  #(length:{maximum: 50}): argument is a hash key which has a hash as value ({length => maximum=>50}), equilent to "user.save if user.name.size < 51"

  validates(:email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}) #see comments above for each argument for the 'validates()' method,the ones for 'format' & 'uniqueness' is below.
  #(format: {with: "..."}): checks wheter the input matches a pattern. '{without: "..."}' checks wheter the input does not match a certain pattern.
  #(uniqueness: true): obviously checks for uniqueness in the DB; a duplicat should not be valid, even if written with a different pattern of upper/downcase chars.

  validates(:password, length: {minimum: 6, maximum: 16}, allow_blank: true) # this 'allow_blank:true' does not let a user sign up with a blank password because of the 'has_secure_password' method activated when a new User instance is created.

  before_save {self.email = self.email.downcase} #guarantees the email will be saved in a standardized downcase format. note that 'before_save' uses a block as input if it is needed to assign a variable.

  def User.digest(string) # this method creates an user fixture (a valid object to be assigned to a test database in order to run tests).
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost # the 'cost' is the computational cost to decypher the string. A low cost makes it easy, a very high cost, nearly impossible.

    BCrypt::Password.create(string, cost: cost) # the value returned will be the string passed as an argument to User.digest() encrypted at the lowest computational cost possible, as it will be only used for testing (the computational cost for production mode will be set to high)
  end

  def User.new_token
    SecureRandom.urlsafe_base64 #'base64' before the generated string(will have .size == 22) will be composed by a-zA-Z0-9 chars and -,_ ; therefore, 64 possibilities.
  end

  def remember # this method will assign a random string to serve as an identifier for cookies; unlike 'session', the 'cookie' method is not secure by default.
    self.remember_token = User.new_token # won't actually save this value in a db.
    update_attribute(:remember_digest, User.digest(remember_token) ) # the method 'update_attribute' bypasses db validations; the generated string is encrypted before being saved on the db so a potential attacker cannot hijack a session using XSS attacks or by capturing the token with a packet sniffer.
  end

  def self.forget # to be used when an user manually logs out of the app, it will destroy the cookie that matches the one saved in the browser and therefore not automatically log in to the app when it is accessed by that computer.
    update_attribute(self.remember_digest, nil)
  end

  def authenticated?(remember_token) # returns true if the given token (which will be automatically sent by the user's browser) matches the digest.
    return false if remember_digest.nil?
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

end
