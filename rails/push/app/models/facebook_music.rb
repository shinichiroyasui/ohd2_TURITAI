class FacebookMusic < ActiveRecord::Base
  attr_accessible :facebook_id, :name

  has_many :user_facebook_musics
  has_many :users, :through => :user_facebook_musics

  class << self
    def parse_and_update_from_facebook_api(music)
      facebook_id = music['id'].to_i
      record = where(facebook_id: facebook_id).first
      record ||= new(facebook_id: facebook_id)
      record.name = music['name']
      record
    end
  end
end
