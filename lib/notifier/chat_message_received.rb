class Notifier::ChatMessageReceived < Notifier::Base
  def message
    message = @twilio_client.api.account.messages.create from: @sender_phone, to: @user_phone, body: @body
    message.sid
  end

  def email
    dump_mail_template_parameters name: 'MessageNotificationRecipient.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:message_notification_recipient],
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  protected

  def mail_template_parameters; end
end
