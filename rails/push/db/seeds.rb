# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(id: 1, gcm_registration_key: 1, birthday: Date.new(1986, 1, 1), gender: Settings.gender.female, android_id: "11")
User.create(id: 2, gcm_registration_key: 2, birthday: Date.new(1986, 1, 1), gender: Settings.gender.male, android_id: "12")
User.create(id: 3, gcm_registration_key: 3, birthday: Date.new(1986, 1, 2), gender: Settings.gender.male, android_id: "13")
