class Notifier::NewGroupMessage < Notifier::UserBase
  def initialize(user:, body:, comment:)
    @comment = comment
    super user: user, body: body, notifiable_user: comment.sender
  end

  def message
    message = @twilio_client.api.account.messages.create from: @sender_phone, to: @user_phone, body: @body
    message.sid
  end

  def email
    dump_mail_template_parameters name: 'MessageNotificationRecipient.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:group_message_creation],
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
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
      avatar: @notifiable_user.avatar
    }
    comment_hash = { content: @comment.content }
    group_hash = {
      name: @comment.group.name,
      chat_link: group_chat_link
    }

    super.update suggested_user: suggested_user_hash,
                 group: group_hash,
                 comment: comment_hash
  end

  def group_chat_link
    ENV['LINK_HOST'] + '/group-chat/' + @comment.group.id.to_s
  end
end
