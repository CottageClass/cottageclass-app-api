class API::EventSeriesController < API::BaseController
  before_action :authenticate_user!

  def index
    render json: EventSeriesSerializer.new(current_user.event_series).serializable_hash,
           status: :ok
  end

  def create
    event_series = current_user.event_series.build safe_params
    if event_series.save
      render json: EventSeriesSerializer.new(event_series).serializable_hash,
             status: :created
    else
      render json: { errors: event_series.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    event_series = current_user.event_series.find params[:id]
    if event_series.update(safe_params)
      render json: EventSeriesSerializer.new(event_series).serializable_hash, status: :ok
    else
      render json: { errors: event_series.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    event_series = current_user.event_series.find params[:id]
    render json: EventSeriesSerializer.new(event_series).serializable_hash, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {}, status: :not_found
  end

  private

  def safe_params
    params.require(:event_series).permit :name, :start_date, :starts_at, :ends_at, :interval,
                                         :maximum_children, :child_age_minimum, :child_age_maximum,
                                         :repeat_for, :place_id, :description
  end
end
