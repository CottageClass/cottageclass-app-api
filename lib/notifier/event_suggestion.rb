class Notifier::EventSuggestion < Notifier::Base
  def initialize(user:, event:, body:)
    super user: user, body: body
    @event = event
  end

  def email
    dump_mail_template_parameters name: 'EventSuggestion.json'
    response = @sendgrid_client.send_mail to: [@user],
                                          from: @sender_email,
                                          template_id: ENV.fetch('SENDGRID_TEMPLATE_EVENT_SUGGESTION'),
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
                                                                 :starts_at
    event_hash.update start_date: @event.start_date,
                      start_day: @event.start_day,
                      time_range: @event.time_range,
                      start_time: @event.start_time,
                      end_time: @event.end_time,
                      host_first_name: @event.host_first_name

    params = super.update event: event_hash
    family_members = ['you'] + @user.children.pluck(:first_name)
    family_string = family_members.slice(0..-2).join(', ') + ' and ' + family_members.last
    params[:recipient].update family_string: family_string
    params
  end
end
