class MessagesController < ApiController
  before_action :authenticate_user
  before_action :require_admin!, only: [:admin_for_pair]

  def create
    # most messages are currently created via TwilioSessionsController#callback
  end

  def admin_for_pair
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
