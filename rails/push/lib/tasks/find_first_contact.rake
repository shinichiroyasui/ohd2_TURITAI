# FirstContactペアを発見し、通知を送信
task :find_first_contact => :environment do
  finder = FirstContactFinder.new
  finder.run
end
