class Notifier::EventReminderPreviousDayHost < Notifier::Base
  def initialize(user:, event:, body:)
    super user: user, body: body
    @event = event
  end

  def email
    dump_mail_template_parameters name: 'EventReminderPreviousDayHost.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:event_reminder_previous_day_host],
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  protected

  def mail_template_parameters
    event_hash = @event.attributes.with_indifferent_access.slice :id,
                                                                 :name,
                                                                 :child_age_minimum,
                                                                 :child_age_maximum

    participant_user_hash_array = @event.participants.map do |participant|
      participant_user_hash = participant.user.attributes.with_indifferent_access.slice :id,
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

      participant_user_hash.update phone: participant.user.phone
    end
    event_hash.update start_date: @event.start_date,
                      time_range: @event.time_range,
                      participants: participant_user_hash_array

    super.update event: event_hash
  end
end
