class UserDestinyScore < ActiveRecord::Base
  attr_accessible :user1_id, :user2_id, :score
  belongs_to :user1, :class_name => 'User'
  belongs_to :user2, :class_name => 'User'
end
