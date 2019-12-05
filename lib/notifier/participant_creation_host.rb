class Notifier::ParticipantCreationHost < Notifier::Base
  def initialize(user:, event:, participant:, body:)
    super user: user, body: body
    @event = event
    @participant = participant
  end

  def email
    dump_mail_template_parameters name: 'ParticipantCreationHost.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:participant_creation_host],
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

    event_hash.update start_date: @event.start_date, time_range: @event.time_range

    participant_user_hash = @participant.user.attributes.with_indifferent_access.slice :id,
                                                                                       :name,
                                                                                       :first_name,
                                                                                       :last_name,
                                                                                       :avatar,
                                                                                       :facebook_uid,
                                                                                       :fuzzy_latitude,
                                                                                       :fuzzy_longitude,
                                                                                       :latitude,
                                                                                       :longitude,
                                                                                       :activities,
                                                                                       :full_address,
                                                                                       :profile_blurb,
                                                                                       :onboarding_care_type,
                                                                                       :job_position,
                                                                                       :employer,
                                                                                       :highest_education,
                                                                                       :images,
                                                                                       :languages

    participant_user_hash.update phone: @participant.user.phone

    super.update event: event_hash, participant_user: participant_user_hash
  end
end
