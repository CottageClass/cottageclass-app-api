class Notifier::EventFeedbackHost < Notifier::Base
  def initialize(user:, event:)
    super user: user
    @event = event
  end

  def message
    body = I18n.t 'messages.event_feedback_host'
    @event.notifications.event_feedback_host.where(recipient: @user).first_or_create body: body
  end
end
