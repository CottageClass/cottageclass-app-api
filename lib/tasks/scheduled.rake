namespace :cottage_class do
  namespace :scheduled do
    desc 'Event Notifier'
    task event_notifier: :environment do
      Participant.next_day.find_each(&:next_day_notify)
      Event.notifiable.find_each(&:notify)
    end

    desc 'Event Generator'
    task :event_generator, [:user_ids] => :environment do |_, arguments|
      skope = Event.where Event.arel_table[:ends_at].between(4.weeks.ago(Time.current)..Time.current)

      user_ids = (arguments[:user_ids] || '').split.map(&:squish).select(&:present?).map(&:to_i).select(&:positive?)
      skope = skope.includes(:event_series).where(event_series: { user_id: user_ids }) if user_ids.present?

      skope.find_each { |event| event.event_series.reload.create_next_event }
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
  end
end
