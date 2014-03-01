task :create_dummy_data => :environment do
  User.delete_all
  User.create(id: 1, googlekey: 1, birthday: Date.new(1986, 1, 1), sex: User::SEX_FEMALE, pois: "1", books: "1", musics: "1")
  User.create(id: 2, googlekey: 2, birthday: Date.new(1986, 1, 1), sex: User::SEX_MALE, pois: "1,2", books: "1,2", musics: "1,2")
  User.create(id: 3, googlekey: 3, birthday: Date.new(1986, 1, 2), sex: User::SEX_MALE, pois: "1,2,3", books: "1,2,3", musics: "1,2,3")
  Pairscore.delete_all
end
