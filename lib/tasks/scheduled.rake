require 'key_value'

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

    desc 'Perform once hourly batched event tasks'
    task batch_event_job: :environment do
      last_run_time = KeyValue['last_batch_event_job_timestamp']
      KeyValue['last_batch_event_job_timestamp'] = Time.current
      if last_run_time.present?
        puts "Performing batch event job.  Last run at #{last_run_time}."
        Event.batch_event_job last_run_time
        puts 'done'
      else
        puts 'Never run before.  Skipping.'
      end
    end
  end
end
