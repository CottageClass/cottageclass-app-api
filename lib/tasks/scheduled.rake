namespace :cottage_class do
  namespace :scheduled do
    desc 'Event Notifier'
    task event_notifier: :environment do
      Participant.next_day.find_each(&:next_day_notify)
      Event.notifiable.find_each(&:notify)
    end
  end
end
