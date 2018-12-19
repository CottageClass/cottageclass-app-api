class API::EventSeriesController < API::BaseController
  before_action :authenticate_user

  def create
    event_series = current_user.event_series.build safe_params
    if event_series.save
      render json: EventSeriesSerializer.new(event_series, include: %i[event_hosts]).serializable_hash, status: :created
    else
      render json: { errors: event_series.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def safe_params
    params.require(:event_series).permit :name, :start_date, :starts_at, :ends_at, :has_pet, :house_rules,
                                         :pet_description,
                                         activity_names: [],
                                         foods: [],
                                         event_hosts_attributes: %i[id name email phone _destroy]
  end
end
