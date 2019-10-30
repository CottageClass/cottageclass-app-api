class API::MessagesController < API::BaseController
  before_action :authenticate_user!, only: %i[index create]
  before_action :load_user

  def index
    messages = Message.with_participants(current_user.id, @user.id).order(created_at: :desc)
    serializer = MessageSerializer.new messages,
                                       params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end

  def create
    Message.create sender: current_user,
                   receiver_id: params.require(:user_id),
                   content: safe_params[:content]
  end

  private

  def load_user
    @user = User.find_by id: params[:user_id]
    render(json: {}, status: :not_found) if @user.blank?
  end

  def safe_params
    params.require(:message).permit :content, :user_id
  end
end
