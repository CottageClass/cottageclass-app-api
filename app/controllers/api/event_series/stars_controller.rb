# frozen_string_literal: true

class API::EventSeries::StarsController < API::StarsController
  before_action :set_starable, only: %i[create destroy index]

  def set_starable
    @starable = EventSeries.find(params[:event_series_id])
  end

  def render_starable(status:)
    event_series = EventSeries.find params[:event_series_id]
    serializer = EventSeriesSerializer.new event_series,
                                           params: { current_user: current_user }
    render json: serializer.serializable_hash, status: status
  end
end
