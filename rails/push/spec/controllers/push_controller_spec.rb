require 'spec_helper'
describe PushController do
  describe "register users" do
    it 'fb => gcm' do
      gcm_registration_key = 'aaa'
      android_id = '123'
      post :fb_token, fb_token: Settings.sample_access_token, android_id: android_id
      post :gcm_registration_key, gcm_registration_key: gcm_registration_key, android_id: android_id
      expect(User.count).to eq(1)
      user = User.first
      expect(user.gcm_registration_key).to eq(gcm_registration_key)
      expect(user.android_id).to eq(android_id)
    end

    it 'gcm => fb' do
      gcm_registration_key = 'aaa'
      android_id = '123'
      post :gcm_registration_key, gcm_registration_key: gcm_registration_key, android_id: android_id
      post :fb_token, fb_token: Settings.sample_access_token, android_id: android_id
      expect(User.count).to eq(1)
      user = User.first
      expect(user.gcm_registration_key).to eq(gcm_registration_key)
      expect(user.android_id).to eq(android_id)
    end
  end
end
