namespace :users do
  desc "Set every user's settings based on existing data"
  task set_settings: :environment do
    puts "Going to update #{User.count} users"

    ActiveRecord::Base.transaction do
      User.all.each do |user|
        user.update_column(:settings, email: { receive_weekly_email: !user.pause_suggestion_email })
        print '.'
      end
    end

    puts ' All done now!'
  end
end
