class Notifier::EventCongratulationHost < Notifier::Base
  def initialize(user:, event:)
    super user: user
    @event = event
  end

  def message
    body = I18n.t 'messages.event_congratulation_host', host_first_name: @user.first_name
    @event.notifications.event_congratulation_host.where(recipient: @user).first_or_create body: body
  end
end
