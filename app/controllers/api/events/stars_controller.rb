class API::Events::StarsController < API::StarsController
  before_action :set_starable, only: %i[create destroy]

  def set_starable
    @starable = Event.find(params[:event_id])
  end
end
