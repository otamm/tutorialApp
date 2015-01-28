class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # the 'default_scope' is a Rails standard to define how something will be manipulated. Now we made the order of the posts to be from most to least recent; the raw, old fashioned Rails + SQL statement  for the argument would be order('created_at DESC')
  # more on 'default_scope': the '->' calls a 'lambda' (an anonymous, nameless function) which returns a proc (a procedure.). To execute the proc, the '.call' method is used. See example at the bottom of the page.
  validates :user_id, presence: true # post is only valid if it is associated with an user.
  validates :content, presence: true, length: { maximum: 140 } # post must have a content, content must have 140 chars at max.


end

#>> -> { puts "foo" }
#=> #<Proc:0x007fab938d0108@(irb):1 (lambda)>
#>> -> { puts "foo" }.call
#foo
#=> nil
