# frozen_string_literal: true

class API::EventSeries::StarsController < API::StarsController
  before_action :set_starable, only: %i[create destroy index]

  def set_starable
    @starable = EventSeries.find(params[:event_series_id])
  end

  def render_starable(status:)
    render status: status
  end
end
