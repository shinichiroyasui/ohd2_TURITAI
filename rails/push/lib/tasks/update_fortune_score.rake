# 運命度の更新
task :update_fortune_score => :environment do
  matcher = DistinyScoreMatcher.new
  matcher.update_all
end
