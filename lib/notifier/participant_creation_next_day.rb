class Notifier::ParticipantCreationNextDay < Notifier::Base
  def message
    Rails.logger.debug format('method not implemented: %s', __method__)
    nil
  end

  def email
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: ENV.fetch('SENDGRID_TEMPLATE_PARTICIPANT_CREATION_NEXT_DAY'),
                                          parameters: {
                                            recipient_name: @user.name
                                          }

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end
end
