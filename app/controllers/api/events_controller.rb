class API::EventsController < API::BaseController
  before_action :authenticate_user

  def index
    render json: EventSerializer.new(current_user.events).serializable_hash, status: :ok
  end
end
