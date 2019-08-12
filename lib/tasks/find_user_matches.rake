namespace :users do
  desc 'Find the best matches for all users'
  task find_all_matches: :environment do
    puts "Finding matches for #{User.count} users"

    ActiveRecord::Base.transaction do
      User.all.each do |user|
        user.find_matches
        print '.'
      end
    end

    puts 'Done finding user matches'
  end
end
