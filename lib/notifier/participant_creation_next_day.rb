class Notifier::ParticipantCreationNextDay < Notifier::Base
  def initialize(user:, event:, body:)
    super user: user, body: body
    @event = event
  end

  def email
    dump_mail_template_parameters name: 'ParticipantCreationNextDay.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:participant_creation_next_day],
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  def message
    Rails.logger.debug format('method not implemented: %s', __method__)
    nil
  end

  protected

  def mail_template_parameters
    event_hash = @event.attributes.with_indifferent_access.slice :id,
                                                                 :name,
                                                                 :child_age_minimum,
                                                                 :child_age_maximum

    host_hash = @event.user.attributes.with_indifferent_access.slice :id,
                                                                     :facebook_uid,
                                                                     :avatar,
                                                                     :first_name,
                                                                     :verified,
                                                                     :child_ages
    host_hash.update full_address: @event.place.full_address
    host_hash.update apartment_number: @event.place.apartment_number

    event_hash.update start_date: @event.start_date,
                      time_range: @event.time_range,
                      host: host_hash
    super.update event: event_hash
  end
end
