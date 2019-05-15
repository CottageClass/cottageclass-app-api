class API::Users::StarsController < API::StarsController
  before_action :set_starable, only: [:create, :destroy]
  
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
    if params[:user_id].to_i == current_user.id
      render status:400 
    end
    @starable = User.find(params[:user_id])
  end

end
