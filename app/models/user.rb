class User < ActiveRecord::Base
  attr_accessor :name, :email
  # on a 'rails console --sandbox', if 'user.valid? == false' use 'user.errors.full_messages' to check for the specific error message.
  validates(:name, presence: true, length: {maximum: 50}) # comments on each argument are below.
  #(presence:true): equivalent to "user.save if user.name.size > 0" in logic, the 'validates()' method also add errors to the screen according to the argument passed ('name can't be blank') for (:name,presence: true)
  #(length:{maximum: 50}): argument is a hash key which has a hash as value ({length => maximum=>50}), equilent to "user.save if user.name.size < 51"

  validates(:email, presence: true, length: {maximum: 255}) #see comments above for each argument for the 'validates()' method.
end
