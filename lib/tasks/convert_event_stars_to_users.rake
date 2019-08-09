namespace :stars do
  desc 'Find any events that were starred and create a star for the host of that event'
  task convert_events_to_users: :environment do
    puts 'Adding stars to any user if they are hosting a starred event'

    ActiveRecord::Base.transaction do
      Star.all.each do |star|
        next unless star.starable_type == 'Event'

        if Star.exists? giver: star.giver, starable_type: 'User', starable_id: star.starable.host_id
          puts 'star exists'
          puts '-- giver: ' + star.giver_id.to_s
          puts '-- user_id: ' + star.starable.host_id.to_s
        else
          puts 'creating a new star'
          puts '-- giver: ' + star.giver_id.to_s
          puts '-- user_id: ' + star.starable.id.to_s
          Star.create giver: star.giver, starable_type: 'User', starable_id: star.starable.host_id
        end
        puts 'deleting event star'
        star.destroy
      end
    end
  end
end
