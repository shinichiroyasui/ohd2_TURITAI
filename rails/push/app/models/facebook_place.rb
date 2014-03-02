class FacebookPlace < ActiveRecord::Base
  attr_accessible :facebook_id, :name

  has_many :user_facebook_places
  has_many :users, :through => :user_facebook_places

  class << self
    def parse_and_update_from_facebook_api(place)
      facebook_id = place['id'].to_i
      record = where(facebook_id: facebook_id).first
      record ||= new(facebook_id: facebook_id)
      record.name = place['name']
      record
    end
  end
end
