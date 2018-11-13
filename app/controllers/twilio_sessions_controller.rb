class TwilioSessionsController < ApplicationController
  before_action :authenticate_user, except: [:callback]

  # - creates a Twilio session
  # - adds participants to the session
  # - does not send a kickoff message - relies on SMS to send that and back to the server for saving
  def create
    careseeker = current_user
    provider = User.find_by(id: params[:id])
    twilio_session = service.proxy_session_for(initiator: careseeker, client: provider)
    # send request message to provider
    service.send_message_to_participant!(cc_twilio_session: twilio_session, sender: careseeker, receiver: provider, message: twilio_params[:request_message])
    # send acknowledgement message to careseeker
    service.send_message_to_participant!(cc_twilio_session: twilio_session, sender: provider, receiver: careseeker, message: twilio_params[:acknowledgment_message])

    # return receiver's textable number (proxy ID)
    render json: TwilioSessionSerializer.json_for(twilio_session), status: 201
  end

  # callback for all twilio interactions
  # - save Messages as they are sent
  # - See: https://www.twilio.com/docs/proxy/api/webhooks#callbackurl
  def callback
    # Twilio doesn't give us a test CallbackUrl
    # - return here to prevent Twilio missing-session errors
    # - comment this out if testing callbacks in dev
    return if ENV['RAILS_ENV'] != 'production'

    twilio_session_sid = params['interactionSessionSid']
    outbound_participant_sid = params['outboundParticipantSid']
    interaction_sid = params['interactionSid']
    message_content = JSON.parse(params['interactionData'])['body']

    # find twilio session and determine which participant sent message
    # - set sender and receiver based on outbound_ppant_id
    twilio_session = TwilioSession.find_by(twilio_sid: twilio_session_sid)
    sender = nil
    receiver = nil
    # if message is going to the client, set receiver as client
    if outbound_participant_sid == twilio_session.twilio_sid_client
      receiver = twilio_session.client
      sender = twilio_session.initiator
    # if message is not going to the client, set receiver as initiator
    elsif outbound_participant_sid == twilio_session.twilio_sid_initiator
      receiver = twilio_session.initiator
      sender = twilio_session.client
    end

    Message.find_or_create_by(
      sender: sender,
      receiver: receiver,
      cc_twilio_session: twilio_session,
      twilio_interaction_sid: interaction_sid,
      content: message_content,
    )

    # update session's last_action_at
    twilio_session.record_action!

    render status: 201
  end


  private

  def service
    @service ||= TwilioService.new
  end

  def session
    @session ||= @client.proxy
      .services(ENV['TWILIO_PROXY_SERVICE_SID'])
      .sessions
  end

  def twilio_params
    params.require(:twilio_session).permit(
      :request_message,
      :acknowledgment_message,
    )
  end
end
