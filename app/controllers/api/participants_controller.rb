class API::ParticipantsController < API::BaseController
  before_action :authenticate_user!, :load_event

  def create
    participant = @event.participants.build
    if participant.update(user: current_user)
      serializer = ParticipantSerializer.new participant
      render json: serializer.serializable_hash, status: :created
    else
      render json: { errors: participant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    json = {}
    participant = @event.participants.find_by user: current_user
    status = if participant.present?
               if participant.destroy
                 :ok
               else
                 json = { errors: participant.errors.full_messages }
                 :unprocessable_entity
               end
             else
               :not_found
             end
    render json: json, status: status
  end

  private

  def load_event
    @event = Event.find_by id: params[:event_id]
    render(json: {}, status: :not_found) if @event.blank?
  end
end
