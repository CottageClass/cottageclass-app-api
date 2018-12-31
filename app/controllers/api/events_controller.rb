class API::EventsController < API::BaseController
  def index
    skope = params[:skope] || 'all'
    render json: EventSerializer.new(Event.send(skope), params: { current_user: current_user }).serializable_hash,
           status: :ok
  end
end
