task :update_fortune_score => :environment do
  # FIXME: 件数が増えると死ぬ！
  users = User.all
STDERR.puts "users: #{users.inspect}"
  users.each do |user1|
    users.each do |user2|
      next if user1 == user2
      #next if user1.sex == user2.sex
STDERR.puts "user1: #{user1.inspect}"
STDERR.puts "user2: #{user2.inspect}"
      score = user1.calc_distiny_score(user2) * 30
STDERR.puts "score: #{score}"
      user_destiny_score = UserDestinyScore.where(user1_id: user1.id)
                                           .where(user1_id: user2.id)
                                           .first
      user_destiny_score ||= UserDestinyScore.new(user1_id: user1.id, user2_id: user2.id)
      user_destiny_score.score = score
      user_destiny_score.save!
    end
  end
end
