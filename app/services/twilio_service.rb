class TwilioService
  NOTIFY_ON_ERROR = [
    '+13104835624',
    '+16144656371'
  ].freeze

  def initialize(twilio_client = nil)
    @twilio_client = twilio_client
  end

  def proxy_session_for(initiator:, client:)
    # -> and query for last_action_at + TTL_SECONDS > now
    existing_sessions = TwilioSession
      .live
      .with_participants(initiator.id, client.id)

    if existing_sessions.count > 0
      proxy_session = existing_sessions.first
    else
      with_alerting(initiator: initiator, client: client, session_id: 'uncreated', method: 'creating proxy session') do
        session_name = unique_name_for_session(initiator.id, client.id)
        # create a new session
        session_obj = create_twilio_proxy_session!(session_name)
        # add the participants to the session
        twilio_initiator_obj = add_participant_to_session!(session_obj.sid, initiator.name, initiator.phone(true))
        twilio_client_obj = add_participant_to_session!(session_obj.sid, client.name, client.phone(true))

        # save the session SID and name
        proxy_session = TwilioSession.create(
          twilio_sid: session_obj.sid,
          friendly_name: session_obj.unique_name,
          initiator_id: initiator.id,
          client_id: client.id,
          twilio_sid_initiator: twilio_initiator_obj.sid,
          twilio_sid_client: twilio_client_obj.sid,
          proxy_identifier_initiator: twilio_initiator_obj.proxy_identifier,
          proxy_identifier_client: twilio_client_obj.proxy_identifier,
          last_action_at: DateTime.now.utc
        )
      end
    end

    proxy_session
  end

  # retrieve correct twilio_sid for participant from TwilioSession object
  def twilio_sid_for_participant(cc_twilio_session:, participant:)
    participant_sid = nil

    if participant.id == cc_twilio_session.client_id
      participant_sid = cc_twilio_session.twilio_sid_client
    elsif participant.id == cc_twilio_session.initiator_id
      participant_sid = cc_twilio_session.twilio_sid_initiator
    end

    participant_sid
  end

  def send_message_to_participant!(cc_twilio_session:, sender:, receiver:, message:)
    with_alerting(initiator: sender, client: receiver, session_id: cc_twilio_session.id, method: 'sending message') do
      twilio_session_sid = cc_twilio_session.twilio_sid
      twilio_receiver_sid = twilio_sid_for_participant(
        cc_twilio_session: cc_twilio_session,
        participant: receiver
      )

      # Send message to ppant
      # - return the receiver's proxy identifier
      # - See: https://www.twilio.com/docs/proxy/quickstart#create-participants
      twilio_msg_obj = send_twilio_message_to_participant!(
        twilio_session_sid,
        twilio_receiver_sid,
        message
      )

      msg = Message.create(
        sender_id: sender.id,
        receiver_id: receiver.id,
        cc_twilio_session_id: cc_twilio_session.id,
        twilio_interaction_sid: twilio_msg_obj.sid,
        content: JSON.parse(twilio_msg_obj.data)['body']
      )
      msg
    end
  end

  private

  def with_alerting(initiator:, client:, session_id:, method:)
    yield
  rescue => e
    # do not alert for errors in dev
    return if ENV['RAILS_ENV'] != 'production'

    # send message to developer, Holmes containing error
    # - TODO: if webhook for "out of proxy numbers" is added, trigger that instead
    # - See: https://www.twilio.com/docs/proxy/api/webhooks#callbackurl
    NOTIFY_ON_ERROR.each do |num|
      twilio_client.messages.create(
        messaging_service_sid: ENV['TWILIO_ALERT_MESSAGING_SERVICE_SID'],
        to: num,
        body: "Error #{method} for participants #{initiator.email}, #{client.email} in session #{session_id}: #{e}"
      )
    end
  end

  def send_twilio_message_to_participant!(twilio_session_sid, twilio_participant_sid, message)
    proxy_service
      .sessions(twilio_session_sid)
      .participants(twilio_participant_sid)
      .message_interactions
      .create(body: message)
  end

  def add_participant_to_session!(session_id, name, phone_w_country_code)
    proxy_service
      .sessions(session_id)
      .participants
      .create(
        friendly_name: name,
        identifier: phone_w_country_code
      )
  rescue Twilio::REST::RestError => e
    # skip retry if participant is already added
    if has_existing_participant?(e)
      # do nothing
    else
      # retry
      add_participant_to_session!(session_id, name, phone_w_country_code)
    end
  end

  def has_existing_participant?(twilio_rest_error)
    twilio_rest_error.error_message.match(/Participant has already been added/) ||
      twilio_rest_error.code == '80103'
  end

  def create_twilio_proxy_session!(session_name)
    proxy_service
      .sessions
      .create(
        unique_name: session_name,
        ttl: TwilioSession::TTL_SECONDS
      )
  end

  def unique_name_for_session(initiator_id, client_id, timestamp = DateTime.now)
    "#{initiator_id}_#{client_id}_#{timestamp.to_i}"
  end

  def twilio_client
    @twilio_client ||= Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def proxy_service
    @proxy_service ||= twilio_client.proxy.services(ENV['TWILIO_PROXY_SERVICE_SID'])
  end
end
