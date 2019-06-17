class API::Events::StarsController < API::StarsController
  before_action :set_starable, only: %i[create destroy index]

  def set_starable
    @starable = Event.find(params[:event_id])
  end

  def render_starable(status:)
    event = Event.find(params[:event_id])
    serializer = EventSerializer.new event, include: %i[ event_hosts
                                                         participants
                                                         participants.participant_children
                                                         user
                                                         user.children
                                                         user.user_reviews
                                                         user.user_reviews.reviewer],
                                            params: { current_user: current_user }
    render json: serializer.serializable_hash, status: status
  end
end
