namespace :cottage_class do
  namespace :scheduled do
    desc 'Event Notifier'
    task event_notifier: :environment do
      Event.notifiable.find_each(&:notify)
    end

    desc 'Send daily digest email to all users'
    task notify_daily_digest: :environment do
      User.all.each(&:notify_daily_digest)
    end
  end
end
