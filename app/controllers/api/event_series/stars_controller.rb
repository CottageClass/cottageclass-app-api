class API::EventSeries::StarsController < API::StarsController
  before_action :set_starable, only: [:create, :destroy]
  
  def set_starable
    @starable = EventSeries.find(params[:event_series_id])
  end
end
