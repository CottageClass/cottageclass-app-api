class TwilioService
  def initialize(twilio_client=nil)
    @client = twilio_client
  end

  def proxy_session_for(sender: , receiver: )
    # -> and query for last_action_at + TTL_SECONDS > now
    existing_sessions = TwilioSession
      .live
      .with_participants([sender.id, receiver.id])

    if existing_sessions.count > 0
      proxy_session = existing_sessions.first
    else
      session_name = unique_name_for_session(sender.id, receiver.id)
      # create a new session
      session_obj = create_twilio_proxy_session!(session_name)
      # add the participants to the session
      twilio_sender_obj = add_participant_to_session!(session_obj.sid, sender.name, sender.phone(true))
      twilio_receiver_obj = add_participant_to_session!(session_obj.sid, receiver.name, receiver.phone(true))
      sender_participant_sid = twilio_sender_obj.sid
      receiver_participant_sid = twilio_receiver_obj.sid
      # save the session SID and name
      proxy_session = TwilioSession.create(
        twilio_sid: session_obj.sid,
        friendly_name: session_obj.unique_name,
        participant_ids: [receiver.id, sender.id],
        twilio_sid_sender: sender_participant_sid,
        twilio_sid_receiver: receiver_participant_sid,
        last_action_at: DateTime.now.utc,
      )
    end

    proxy_session
  end

  def send_introductory_message_to!(cc_twilio_session:, receiver:, sender:)
    # send an introductory message to the receiver
    message_text = introductory_message_text(receiver.name, sender.name)

    send_message_to_participant!(
      cc_twilio_session: cc_twilio_session,
      sender: sender,
      receiver: receiver,
      message: message_text,
    )
  end

  def send_message_to_participant!(cc_twilio_session:, sender:, receiver:, message:)
    twilio_session_sid = cc_twilio_session.twilio_sid
    twilio_participant_sid = cc_twilio_session.twilio_sid_receiver

    # TODO: may not need to actually push the message in, may be enough to send user to SMS with the twilio session number
    # - return the receiver's proxy identifier
    # - See: https://www.twilio.com/docs/proxy/quickstart#create-participants
    twilio_msg_obj = send_twilio_message_to_participant!(twilio_session_sid, twilio_participant_sid, message)

    msg = Message.create(
      sender_id: sender.id,
      receiver_id: receiver.id,
      cc_twilio_session_id: cc_twilio_session.id,
      twilio_interaction_sid: twilio_msg_obj.sid,
      content: JSON.parse(twilio_msg_obj.data)['body'],
    )
    msg
  end


  private

  def introductory_message_text(receiver_name, sender_name)
    <<~HEREDOC
      Hi #{receiver_name}! Would you be available for childcare today?

      Thanks!

      #{sender_name}
    HEREDOC
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
        identifier: phone_w_country_code,
      )
  end

  def create_twilio_proxy_session!(session_name)
    proxy_service
      .sessions
      .create(
        unique_name: session_name,
        ttl: TwilioSession::TTL_SECONDS,
      )
  end

  def unique_name_for_session(sender_id, receiver_id, timestamp=DateTime.now)
    "#{sender_id}_#{receiver_id}_#{timestamp.to_i}"
  end

  def client
    @client ||= Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def proxy_service
    @proxy_service ||= client.proxy.services(ENV['TWILIO_PROXY_SERVICE_SID'])
  end
end
