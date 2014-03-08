# coding: utf-8
require 'spec_helper'
require 'distiny_score_matcher'

describe DistinyScoreMatcher do
  before do
    # FIXME: FactoryGirlとか, Fixtureとかに書き換える
    music1 = FacebookMusic.create(facebook_id: 485451388203145, name: "TWO-FIVE")
    music2 = FacebookMusic.create(facebook_id: 103714333000218, name: "Ikimono-gakari")

    @place1 = FacebookPlace.create(facebook_id: 350754054997029, name: "ハバナカフェ")
    place2 = FacebookPlace.create(facebook_id: 131027056964895, name: "だるまや")

    birthday1 = Date.new(1986, 1, 1)
    birthday2 = Date.new(1986, 1, 2)
    @user1 = User.create(facebook_id: 1, gcm_registration_key: 1, birthday: birthday1, gender: Settings.gender.female, android_id: "11")
    @user1.facebook_musics << music1
    @user1.facebook_musics << music2
    @user1.facebook_places << @place1
    @user1.facebook_places << place2

    @user2 = User.create(facebook_id: 2, gcm_registration_key: 2, birthday: birthday1, gender: Settings.gender.male, android_id: "12")
    @user2.facebook_musics << music1
    @user2.facebook_musics << music2
    @user2.facebook_places << @place1
    @user2.facebook_places << place2

    @user3 = User.create(facebook_id: 3, gcm_registration_key: 3, birthday: birthday2, gender: Settings.gender.male, android_id: "13")
  end

  it 'matches the user who has biggest distiny score for @user1.' do
    matcher = DistinyScoreMatcher.new
    matcher.update_all
    user_place = UserFacebookPlace.new(:user_id => @user1.id, :facebook_place_id => @place1.id)
    target_user = matcher.find_target_user(user_place)
    expect(target_user).to eq(@user2)
  end
end

