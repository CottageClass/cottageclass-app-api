class Notifier::EventFeedbackHost < Notifier::Base
  def email
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: ENV.fetch('SENDGRID_TEMPLATE_EVENT_FEEDBACK_HOST'),
                                          parameters: {
                                            recipient_name: @user.name
                                          }

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end
end
