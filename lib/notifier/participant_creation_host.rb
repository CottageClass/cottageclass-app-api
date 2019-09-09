class Notifier::ParticipantCreationHost < Notifier::Base
  def initialize(user:, event:, participant:, body:)
    super user: user, body: body
    @event = event
    @participant = participant
  end

  def message
    Rails.logger.debug format('method not implemented: %s', __method__)
    nil
  end

  def email
    dump_mail_template_parameters name: 'ParticipantCreationHost.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: ENV.fetch('SENDGRID_TEMPLATE_PARTICIPANT_CREATION_HOST'),
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  protected

  def mail_template_parameters
    event_hash = @event.attributes.with_indifferent_access.slice :id,
                                                                 :name,
                                                                 :maximum_children,
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
                                                                                       :school,
                                                                                       :instagram_user,
                                                                                       :twitter_user,
                                                                                       :linkedin_user,
                                                                                       :images,
                                                                                       :languages

    participant_user_children_hash_array = @participant.participant_children.map do |participant_child|
      participant_child_hash = participant_child.child.attributes.with_indifferent_access.slice :id,
                                                                                                :first_name,
                                                                                                :school_name,
                                                                                                :allergies,
                                                                                                :dietary_restrictions,
                                                                                                :special_needs

      emergency_contact_hash_array = participant_child.child.emergency_contacts.map do |emergency_contact|
        emergency_contact.attributes.with_indifferent_access.slice :id, :name, :phone_number, :relationship
      end
      participant_child_hash.update age: participant_child.child.age, emergency_contacts: emergency_contact_hash_array
    end

    participant_user_hash.update participant_children: participant_user_children_hash_array,
                                 phone: @participant.user.phone

    super.update event: event_hash, participant_user: participant_user_hash
  end
end
