class API::ParticipantsController < API::BaseController
  before_action :authenticate_user, :verify_parent

  def create
    participant = event_series.participants.build safe_params
    if participant.update(user: current_user)
      render json: {},
             status: :created
    else
      render json: { errors: participant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def verify_parent
    render(json: {}, status: :not_found) if event_series.blank?
  end

  def event_series
    EventSeries.find_by id: params[:event_series_id]
  end

  def safe_params
    params.require(:participant).permit participant_children_attributes: [:child_id]
  end
end
