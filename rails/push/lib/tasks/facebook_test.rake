require "facebook"

task :facebook_test => :environment do
  access_token = Settings.sample_access_token
  facebook = Facebook.new(access_token)
  user = facebook.generate_user!
  puts user.inspect
end
