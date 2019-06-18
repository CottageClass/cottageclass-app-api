namespace :cottage_class do
  desc 'Run once with new matching logic'
  task find_all_matches: :environment do
    User.all.each(&:find_matches)
  end
end
