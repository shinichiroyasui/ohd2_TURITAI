# coding: utf-8
require 'spec_helper'

describe User do
  before do
    # FIXME: FactoryGirlとか, Fixtureとかに書き換える
    music1 = FacebookMusic.create(facebook_id: 485451388203145, name: "TWO-FIVE")
    music2 = FacebookMusic.create(facebook_id: 103714333000218, name: "Ikimono-gakari")

    place1 = FacebookPlace.create(facebook_id: 350754054997029, name: "ハバナカフェ")
    place2 = FacebookPlace.create(facebook_id: 131027056964895, name: "だるまや")

    birthday1 = Date.new(1986, 1, 1)
    birthday2 = Date.new(1986, 1, 2)
    @user1 = User.create(facebook_id: 1, gcm_registration_key: 1, birthday: birthday1, gender: Settings.gender.female, android_id: "11")
    @user1.facebook_musics << music1
    @user1.facebook_musics << music2
    @user1.facebook_places << place1
    @user1.facebook_places << place2

    @user2 = User.create(facebook_id: 2, gcm_registration_key: 2, birthday: birthday1, gender: Settings.gender.male, android_id: "12")
    @user2.facebook_musics << music1
    @user2.facebook_musics << music2
    @user2.facebook_places << place1
    @user2.facebook_places << place2

    @user3 = User.create(facebook_id: 3, gcm_registration_key: 3, birthday: birthday2, gender: Settings.gender.male, android_id: "13")
  end

  it 'perect match' do
    expect(@user1.calc_distiny_score(@user2)).to eq(3.0)
  end

  it 'no match' do
    expect(@user1.calc_distiny_score(@user3)).to eq(0)
  end
end
