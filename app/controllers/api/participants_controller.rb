class API::ParticipantsController < API::BaseController
  before_action :authenticate_user, :verify_event

  def create
    participant = event.participants.build safe_params
    if participant.update(user: current_user)
      serializer = ParticipantSerializer.new participant, include: %i[participant_children]
      render json: serializer.serializable_hash, status: :created
    else
      render json: { errors: participant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def verify_event
    render(json: {}, status: :not_found) if event.blank?
  end

  def event
    Event.find_by id: params[:event_id]
  end

  def safe_params
    params.require(:participant).permit participant_children_attributes: [:child_id]
  end
end
