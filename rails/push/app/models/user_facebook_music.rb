class UserFacebookMusic < ActiveRecord::Base
  attr_accessible :user_id, :facebook_music_id

  belongs_to :user
  belongs_to :facebook_music
end
