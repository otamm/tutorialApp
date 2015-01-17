class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #constant for the RegEx that validates the e-mail; more info on README.md
  has_secure_password #method used with bcrypt gem, which uses cryptographic hash functions before storing a password (http://en.wikipedia.org/wiki/Hash_function)

  # on a 'rails console --sandbox', if 'user.valid? == false' use 'user.errors.full_messages' to check for the specific error message.
  validates(:name, presence: true, length: {maximum: 50}) # comments on each argument are below.
  #(presence:true): equivalent to "user.save if user.name.size > 0" in logic, the 'validates()' method also add errors to the screen according to the argument passed ('name can't be blank') for (:name,presence: true)
  #(length:{maximum: 50}): argument is a hash key which has a hash as value ({length => maximum=>50}), equilent to "user.save if user.name.size < 51"

  validates(:email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}) #see comments above for each argument for the 'validates()' method,the ones for 'format' & 'uniqueness' is below.
  #(format: {with: "..."}): checks wheter the input matches a pattern. '{without: "..."}' checks wheter the input does not match a certain pattern.
  #(uniqueness: true): obviously checks for uniqueness in the DB; a duplicat should not be valid, even if written with a different pattern of upper/downcase chars.

  validates(:password, length: {minimum: 6, maximum: 16})

  before_save {self.email = self.email.downcase} #guarantees the email will be saved in a standardized downcase format. note that 'before_save' uses a block as input if it is needed to assign a variable.
end
