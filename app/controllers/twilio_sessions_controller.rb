class TwilioSessionsController < ApplicationController
  before_action :authenticate_user

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
