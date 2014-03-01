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
      score = user1.fortune_score(user2) * 30
STDERR.puts "score: #{score}"
      pairscore = Pairscore.where(userid1: user1.id)
                           .where(userid2: user2.id)
                           .first
      pairscore ||= Pairscore.new(userid1: user1.id, userid2: user2.id)
      pairscore.score = score
      pairscore.save!
    end
  end
end
