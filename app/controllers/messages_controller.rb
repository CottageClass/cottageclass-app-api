class MessagesController < ApplicationController
  before_action :authenticate_user

  # in future, this will create a message
  # - for now, this:
  #   - creates a Twilio session
  #   - adds participants to the session
  #   - sends a kickoff message
  def create
    sender = current_user
    receiver = User.find_by(id: params[:id])
    twilio_session = service.proxy_session_for(sender: sender, receiver: receiver)
    service.send_introductory_message_to!(
      session: twilio_session,
      receiver: receiver,
      sender: sender
    )

    # return session ID? message? -> no, just needs to be GETable later
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

  def message_params
    params.require(:message).permit(
      :receiver_id,
      :sender_id,
      :content,
    )
  end
end
