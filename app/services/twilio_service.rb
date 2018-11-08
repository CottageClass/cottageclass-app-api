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
      sender_participant_sid = add_participant_to_session!(session_obj.sid, sender.name, sender.phone(true))
      receiver_participant_sid = add_participant_to_session!(session_obj.sid, receiver.name, receiver.phone(true))
      # save the session SID and name
      proxy_session = TwilioSession.create(
        twilio_sid: session_obj.sid,
        friendly_name: session_obj.unique_name,
        participant_ids: [receiver.id, sender.id],
        twilio_sid_sender: sender_participant_sid,
        twilio_sid_receiver: receiver_participant_sid,
        last_action_at: DateTime.now,
      )
    end

    proxy_session
  end

  def send_introductory_message_to!(session:, receiver:, sender:)
    # send an introductory message to the receiver
    msg = introductory_message_text(receiver.name, sender.name)
    twilio_msg_obj = send_message_to_participant!(
      session.twilio_sid,
      session.twilio_sid_receiver,
      msg,
    )
    msg = Message.create(
      sender_id: sender.id,
      receiver_id: receiver.id,
      cc_twilio_session_id: session.id,
      twilio_interaction_sid: twilio_msg_obj.sid,
      content: twilio_msg_obj.data,
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

  def send_message_to_participant!(twilio_session_sid, twilio_participant_sid, message_text)
    proxy_service
      .sessions(twilio_session_sid)
      .participants(twilio_participant_sid)
      .message_interactions
      .create(body: message_text)
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
