class Notifier::DailyDigest < Notifier::Base
  def initialize(user:, event_collection:, body:)
    super user: user, body: body
    @events = event_collection.events
  end

  def email
    dump_mail_template_parameters name: 'DailyDigest.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: sendgrid_template[:daily_digest],
                                          parameters: mail_template_parameters.deep_stringify_keys

    (response.try(:headers) || {}).dig('x-message-id').try :first
  end

  def message
    Rails.logger.debug format('method not implemented: %s', __method__)
    nil
  end

  protected

  def mail_template_parameters
    events_hash = @events.map do |event|
      user_hash = event.user.attributes.with_indifferent_access.slice :first_name, :id, :avatar
      user_hash.update last_initial: event.user.last_name[0].capitalize

      event_attributes = %i[id name child_age_minimum child_age_maximum]
      event_hash = event.attributes.with_indifferent_access.slice(*event_attributes)

      place_hash = event.place.attributes.with_indifferent_access.slice :full_address
      place_hash.update name: place_name(event)

      event_hash.update user: user_hash,
                        place: place_hash,
                        name: event.name,
                        description: event.description,
                        link: "#{ENV['LINK_HOST']}/event/#{event.id}",
                        distance: event_distance(event),
                        start_time: event.start_time,
                        end_time: event.end_time,
                        image: event.image,
                        day: event.start_day_abbreviated,
                        date: event.start_date_abbreviated_short_month
    end
    super.update events: events_hash
  end

  def event_distance(event)
    dist = event.place.distance_to @user.place
    "#{dist.round(1)} miles"
  end

  def place_name(event)
    if event.place.public?
      event.place.name
    else
      "#{event.user.first_name}'s home"
    end
  end
end
