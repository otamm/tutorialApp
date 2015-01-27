class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true # post is only valid if it is associated with an user.
end
