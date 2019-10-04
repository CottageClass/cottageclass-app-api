require 'key_value'

namespace :places do
  desc 'convert every user location to a place'
  task update_place_details: :environment do |t|
    puts "running #{t.name}"
    already_run = KeyValue[t.name].present?
    if !already_run
      ActiveRecord::Base.transaction do
        Place.all.map(&:update_details_from_api)

        puts 'done'
        KeyValue[t.name] = true
      end
    else
      puts "The task #{t.name} has already been run"
    end
  end
end
