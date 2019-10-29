class API::ConversationsController < API::BaseController
  before_action :authenticate_user!

  def index
    convos = Conversation.with_participant current_user
    serializer = ConversationSerializer.new convos,
                                            params: { current_user: current_user },
                                            include: %i[last_message partner]
    render json: serializer.serializable_hash, status: :ok
  end
end
