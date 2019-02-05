class Notifier::EventFeedbackHost < Notifier::Base
  def initialize(user:, event:, body:)
    super user: user, body: body
    @event = event
  end

  def email
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: ENV.fetch('SENDGRID_TEMPLATE_EVENT_FEEDBACK_HOST'),
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  protected

  def mail_template_parameters
    event_hash = @event.attributes.with_indifferent_access.slice :id,
                                                                 :name,
                                                                 :maximum_children,
                                                                 :child_age_minimum,
                                                                 :child_age_maximum,
                                                                 :has_pet,
                                                                 :activity_names,
                                                                 :foods,
                                                                 :house_rules,
                                                                 :pet_description
    event_hash.update start_date: @event.start_date,
                      time_range: @event.time_range
    super.update event: event_hash
  end
end
