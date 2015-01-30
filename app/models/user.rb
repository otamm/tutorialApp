class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :activated, :activated_at
  attr_accessor :remember_token,  :activation_token, :reset_token
  before_save :downcase_email #runs the method before a .save method when this is called.
  before_create :create_activation_digest # runs the method before a .create method to associate an activation digest with an user just before s/he is saved on the DB.
  has_many :microposts, dependent: :destroy # assures that all microposts associated with an user are destroyed when the user itself is destroyed.


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
    remember_token = User.new_token # won't actually save this value in a db. 'remember_token' is independent from user, 'remember_digest' it's not.
    update_attribute(:remember_digest, User.digest(remember_token)) # the method 'update_attribute' bypasses db validations; the generated string is encrypted before being saved on the db so a potential attacker cannot hijack a session using XSS attacks or by capturing the token with a packet sniffer.
  end

  def forget # to be used when an user manually logs out of the app, it will destroy the cookie that matches the one saved in the browser and therefore not automatically log in to the app when it is accessed by that computer.
    self.update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token) # returns true if the given token (which will be automatically sent by the user's browser) matches the digest.
    digest = self.send("#{attribute}_digest") # will pass the specific method that ends with '_digest' to this instance of the User object and return the attribute value. See 'metaprogramming'
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate # activates the account.
    self.update_attribute(:activated, true) # 'self.' is optional inside models.
    self.update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now # sends an email for the e-mail registered along this instance of the User object.
  end

  def create_reset_digest # sets the password reset attributes. associates a virtual attribute to serve as a reset token.
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token) )
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email # sends the password reset e-mail with a link to the reset page.
    UserMailer.password_reset(self).deliver_now # defined on mailers/user_mailer.rb
  end

  def password_reset_expired? # returns 'true' if the password reset token has been sent for more than 'x' hours.
    reset_sent_at < 2.hours.ago # the time window for the creation and activation of the reset link cannot exceed 2 hours.
  end

  def feed
    Micropost.where("user_id = ?", id) # Used to display a feed on the home page. 
  end

  private

  def downcase_email # this method will be called before saving the e-mail on the db, will guarantee a downcased e-mail.
    self.email = self.email.downcase
  end

  def create_activation_digest # will generate a random string for an user as soon as s/he signs up. The string will be associated with the account until the e-mail is confirmed.
    activation_token = User.new_token # defined on this model, generates a random string.
    self.activation_digest = User.digest(activation_token) # also defined on this model, generates a digested string (assigned here to the activation_digest)
  end

end
