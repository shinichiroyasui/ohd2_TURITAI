class FacebookPlace < ActiveRecord::Base
  attr_accessible :facebook_id, :name

  has_many :user_facebook_places
  has_many :users, :through => :user_facebook_places
end
