namespace :cottage_class do
  namespace :scheduled do
    desc 'Event Notifier'
    task event_notifier: :environment do
      Event.notifiable.find_each(&:notify)
    end
  end
end
