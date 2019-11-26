class Notifier::EventFeedbackHost < Notifier::Base
  def initialize(user:, event:, body:)
    super user: user, body: body
    @event = event
  end

  def email
    dump_mail_template_parameters name: 'EventFeedbackHost.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:event_feedback_host],
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  protected

  def mail_template_parameters
    event_hash = @event.attributes.with_indifferent_access.slice :id,
                                                                 :name,
                                                                 :child_age_minimum,
                                                                 :child_age_maximum
    event_hash.update start_date: @event.start_date,
                      time_range: @event.time_range
    super.update event: event_hash
  end
end
