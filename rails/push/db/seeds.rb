# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

music1 = FacebookMusic.create(facebook_id: 485451388203145, name: "TWO-FIVE")
music2 = FacebookMusic.create(facebook_id: 103714333000218, name: "Ikimono-gakari")

place1 = FacebookPlace.create(facebook_id: 350754054997029, name: "ハバナカフェ")
place2 = FacebookPlace.create(facebook_id: 131027056964895, name: "だるまや")

user1 = User.create(facebook_id: 1, gcm_registration_key: 1, birthday: Date.new(1986, 1, 1), gender: Settings.gender.female, android_id: "11")
user1.facebook_musics << music1
user1.facebook_musics << music2
user1.facebook_places << place1
user1.facebook_places << place2

user2 = User.create(facebook_id: 2, gcm_registration_key: 2, birthday: Date.new(1986, 1, 1), gender: Settings.gender.male, android_id: "12")
user2.facebook_musics << music1
user2.facebook_places << place1

user3 = User.create(facebook_id: 3, gcm_registration_key: 3, birthday: Date.new(1986, 1, 2), gender: Settings.gender.male, android_id: "13")
user3.facebook_musics << music2
user3.facebook_places << place2
