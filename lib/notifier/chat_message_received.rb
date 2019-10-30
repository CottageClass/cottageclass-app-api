class Notifier::ChatMessageReceived < Notifier::Base
  def message
    message = @twilio_client.api.account.messages.create from: @sender_phone, to: @user_phone, body: @body
    message.sid
  end

  def email
    Rails.logger.debug format('method not implemented yet: %s', __method__)
    nil
  end
end
