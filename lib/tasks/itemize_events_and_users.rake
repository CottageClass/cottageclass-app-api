namespace :cottage_class do
  desc 'Add an item for each existing user and event.  Run once after migration'
  task itemize_events_and_users: :environment do
    User.all.each do |user|
      ap user.id
      SearchListItem.create!(user: user)
    end
    Event.all.each do |event|
      SearchListItem.create(user: event.user, itemable: event)
    end
  end
end
