class API::EventsController < API::BaseController
  before_action :authenticate_user, except: %i[index]

  def index
    skope = params[:skope] || 'all'
    render json: EventSerializer.new(Event.send(skope)).serializable_hash, status: :ok
  end
end
