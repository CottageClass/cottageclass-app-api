class Notifier::EventReminderSameDayParticipant < Notifier::Base
  def initialize(user:, event:)
    super user: user
    @event = event
  end

  def message
    body = I18n.t 'messages.event_reminder_same_day_participant', participant_first_name: @user.first_name,
                                                                  host_first_name: @event.host_first_name,
                                                                  event_time_range: @event.time_range
    @event.notifications.event_reminder_same_day_participant.where(recipient: @user).first_or_create body: body
  end
end
