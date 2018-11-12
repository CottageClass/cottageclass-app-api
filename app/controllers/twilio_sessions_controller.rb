class TwilioSessionsController < ApplicationController
  before_action :authenticate_user, except: [:callback]

  # - creates a Twilio session
  # - adds participants to the session
  # - does not send a kickoff message - relies on SMS to send that and back to the server for saving
  def create
    sender = current_user
    receiver = User.find_by(id: params[:id])
    twilio_session = service.proxy_session_for(sender: sender, receiver: receiver)

    # return receiver's textable number (proxy ID)
    render json: TwilioSessionSerializer.json_for(twilio_session), status: 201
  end

  # callback for all twilio interactions
  # - save Messages as they are sent
  # - See: https://www.twilio.com/docs/proxy/api/webhooks#callbackurl
  def callback
    twilio_session_sid = params['interactionSessionSid']
    outbound_participant_sid = params['outboundParticipantSid']
    interaction_sid = params['interactionSid']
    content = JSON.parse(params['interactionData'])['body']

    # find twilio session and determine which participant sent message
    # - set sender and receiver based on outbound_ppant_id
    twilio_session = TwilioSession.find_by(twilio_sid: twilio_session_sid)
    sender = nil
    receiver = nil
    if outbound_participant_sid == twilio_session.twilio_sid_receiver
      receiver = twilio_session.receiver
      sender = twilio_session.sender
    else
      receiver = twilio_session.sender
      sender = twilio_session.receiver
    end

    Message.find_or_create_by(
      sender: sender,
      receiver: receiver,
      cc_twilio_session: twilio_session,
      twilio_interaction_sid: interaction_sid,
      content: content,
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
      :content,
    )
  end
end
