class UserDestinyScore < ActiveRecord::Base
  attr_accessible :score
  blongs_to :user1, :class_name => 'User'
  blongs_to :user2, :class_name => 'User'
end
