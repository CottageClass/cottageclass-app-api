class API::EventsController < API::BaseController
  def index
    skope = params[:skope] || 'all'
    serializer = EventSerializer.new Event.send(skope), include: %i[event_hosts],
                                                        params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end
end
