class API::Events::StarsController < API::StarsController
  before_action :set_starable, only: %i[create destroy index]

  def set_starable
    @starable = Event.find(params[:event_id])
  end

  def render_starable(status:)
    event = Event.find(params[:event_id])
    serializer = EventSerializer.new event, include: %i[ participants
                                                         user
                                                         user.children],
                                            params: { current_user: current_user }
    render json: serializer.serializable_hash, status: status
  end
end
