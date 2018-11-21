class MessagesController < ApiController
  #before_action :authenticate_user

  def create
    # most messages are currently created via TwilioSessionsController#callback
  end

  def for_pair
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]
    @msgs = Message.with_participants(sender_id, receiver_id)

    render json: MessageSerializer.json_for(@msgs), status: 200
  end


  private

  def message_params
    params.require(:message).permit(
      :sender_id,
      :receiver_id,
    )
  end
end
