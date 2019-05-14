
class API::Users::StarsController < API::StarsController
  def index
    # get all the starables that this user has starred
    if current_user && current_user.id == params[:user_id].to_i
      serializer = UserGivenStarsSerializer.new current_user, include: %i[starred_users starred_events starred_event_series]
      render json: serializer.serializable_hash, status: :ok
    else
      render status: 401
    end

  end
end
