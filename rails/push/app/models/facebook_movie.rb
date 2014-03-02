class FacebookMovie < ActiveRecord::Base
  attr_accessible :facebook_id, :name

  has_many :user_facebook_movies
  has_many :users, :through => :user_facebook_movies

  class << self
    def parse_and_update_from_facebook_api(music)
      facebook_id = movie['id'].to_i
      record = where(facebook_id: facebook_id).first
      record ||= new(facebook_id: facebook_id)
      record.name = movie['name']
      record
    end
  end
end
