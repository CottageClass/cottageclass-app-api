require 'key_value'

namespace :cottage_class do
  namespace :scheduled do
    desc 'Event Notifier'
    task event_notifier: :environment do
      Participant.next_day.find_each(&:next_day_notify)
      Event.notifiable.find_each(&:notify)
    end

    desc 'Update every event with a recency score and every user with the best event'
    task update_showcase: :environment do
      pp 'Starting hourly task to update recency scores and showcase events'
      Event.all.each(&:update_recency_score)
      User.all.each(&:update_showcase_event)
      pp 'Finished updating recency scores and showcase events'
    end

    desc 'Send event suggestion emails to all users that have a suggestable event'
    task notify_suggested_events: :environment do
      User.all.each(&:notify_event_suggestion)
    end

    desc 'Send user suggestion emails to all users that have a suggestable user'
    task notify_suggested_users: :environment do
      puts 'Sending user suggestions for users: ' + User.count.to_s
      User.all.each(&:notify_user_suggestion)
      puts 'done'
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
