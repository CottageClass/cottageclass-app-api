require 'key_value'

namespace :users do
  desc 'convert every user location to a place'
  task create_user_places: :environment do |t|
    puts "running #{t.name}"
    already_run = KeyValue[t.name].present?
    if !already_run
      ActiveRecord::Base.transaction do
        gp = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
        users = User.all
        puts "addling places to #{users.count} users"
        users.each do |u|
          spots = gp.spots_by_query u.full_address
          if spots.empty?
            puts "User with id: #{u.id} has no spots"
          else
            puts "User with id: #{u.id} has more than one spot" if spots.count > 1
            # add a place to this user
            google_id = spots.first.place_id
            place = Place.find_by google_id: google_id
            if place.nil?
              place = u.created_places.build google_id: google_id, public: false
              place.save
            end
            u.update_columns place_id: place.id
            u.event_series.each do |es|
              es.update_columns place_id: place.id
            end
          end
        end

        puts 'done'
        KeyValue[t.name] = true
      end
    else
      puts "The task #{t.name} has already been run"
    end
  end
end
