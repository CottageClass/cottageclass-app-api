class Notifier::ChatMessageReceived < Notifier::UserBase
  def initialize(user:, body:, message:)
    super user: user, body: body, notifiable_user: message.sender
  end

  def message
    if @user.setting_notify_messages_sms
      message = @twilio_client.api.account.messages.create from: @sender_phone, to: @user_phone, body: @body
      message.sid
    end
  end

  def email
    if @user.setting_notify_messages_email
      dump_mail_template_parameters name: 'MessageNotificationRecipient.json'
      response = @sendgrid_client.send_mail to: [@user],
                                            from: @sender_email,
                                            template_id: sendgrid_template[:message_notification_recipient],
                                            parameters: mail_template_parameters.deep_stringify_keys

      (response.try(:headers) || {}).dig('x-message-id').try :first
    else
      Rails.logger.debug format('method not implemented: %s', __method__)
      nil
    end
  end

  protected

  def mail_template_parameters
    suggested_user_hash = {
      first_name: @notifiable_user.first_name.capitalize,
      last_initial: @notifiable_user.last_initial,
      distance: distance_with_units,
      kids_ages_sentence_string: kids_ages_count_string,
      kids_ages_standalone_string: kids_ages_count_string,
      bio: truncated_bio,
      bio_truncated: bio_truncated?,
      neighborhood: @notifiable_user.place&.neighborhood || '',
      avatar: @notifiable_user.avatar,
      chat_link: chat_link
    }

    super.update suggested_user: suggested_user_hash
  end
end
