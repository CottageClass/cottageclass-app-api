namespace :cottage_class do
  namespace :scheduled do
    desc 'Event Notifier'
    task event_notifier: :environment do
      Participant.next_day.find_each(&:next_day_notify)
      Event.notifiable.find_each(&:notify)
    end

    desc 'Event Generator'
    task event_generator: :environment do
      Event.where(Event.arel_table[:ends_at].between(4.weeks.ago(Time.current)..Time.current)).find_each do |event|
        event.event_series.reload.create_next_event
      end
    end
  end
end
