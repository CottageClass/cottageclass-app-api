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

    desc 'Update every event with a recency score'
    task update_evnnt_scores: :environment do
      Event.all.each(&:update_recency_score) # saving event should update recency score
    end
  end
end
