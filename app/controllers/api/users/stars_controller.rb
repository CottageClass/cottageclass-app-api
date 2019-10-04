class API::Users::StarsController < API::StarsController
  before_action :set_starable, only: %i[create destroy index]

  def index
    # get all the starables that this user has starred
    if current_user.id == params[:user_id].to_i
      serializer = UserGivenStarsSerializer.new current_user,
                                                include: %i[starred_users starred_events]
      render json: serializer.serializable_hash, status: :ok
    else
      render status: 401
    end
  end

  def set_starable
    render status: 400 if params[:user_id].to_i == current_user.id
    @starable = User.find(params[:user_id])
  end

  private

  def render_starable(status:)
    user = User.find(params[:user_id])
    serializer = PublicUserSerializer.new user,
                                          include: %i[children place],
                                          params: { current_user: current_user }
    render json: serializer.serializable_hash, status: status
  end
end
