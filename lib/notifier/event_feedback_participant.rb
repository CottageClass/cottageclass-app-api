class Notifier::EventFeedbackParticipant < Notifier::Base
  def initialize(user:, event:)
    super user: user
    @event = event
  end

  def message
    body = I18n.t 'messages.event_feedback_participant', participant_first_name: @user.first_name
    @event.notifications.event_feedback_participant.where(recipient: @user).first_or_create body: body
  end
end
