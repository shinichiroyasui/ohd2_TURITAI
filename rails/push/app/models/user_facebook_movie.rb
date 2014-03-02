class UserFacebookMovie < ActiveRecord::Base
  attr_accessible :user_id, :facebook_movie_id

  belongs_to :user
  belongs_to :facebook_movie
end
