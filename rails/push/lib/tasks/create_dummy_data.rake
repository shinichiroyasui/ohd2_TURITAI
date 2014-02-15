task :create_dummy_data => :environment do
  User.delete_all
  User.create({id: 1, googlekey: 1, birthday: Date.new(1986, 1, 1), sex: User::SEX_FEMALE})
  User.create({id: 2, googlekey: 2, birthday: Date.new(1986, 1, 1), sex: User::SEX_MALE})
  User.create({id: 3, googlekey: 3, birthday: Date.new(1986, 1, 2), sex: User::SEX_MALE})
  Pairscore.delete_all
end
