class UserFacebookPlace < ActiveRecord::Base
  attr_accessible :user_id, :facebook_place_id

  belongs_to :user
  belongs_to :facebook_place
end
