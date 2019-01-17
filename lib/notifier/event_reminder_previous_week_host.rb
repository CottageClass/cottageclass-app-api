class Notifier::EventReminderPreviousWeekHost < Notifier::Base
  def initialize(user:, event:)
    super user: user
    @event = event
  end

  def message
    body = I18n.t 'messages.event_reminder_previous_week_host', host_first_name: @user.first_name,
                                                                event_start_date: @event.start_date,
                                                                event_time_range: @event.time_range
    @event.notifications.event_reminder_previous_week_host.where(recipient: @user).first_or_create body: body
  end
end
