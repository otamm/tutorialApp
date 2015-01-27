class Micropost < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true # post is only valid if it is associated with an user.
  validates :content, presence: true, length: { maximum: 140 } # post must have a content, content must have 140 chars at max.
end
