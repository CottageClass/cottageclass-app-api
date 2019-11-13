class API::PlacesController < API::BaseController
  def show
    place = Place.find params[:id]
    if place.present?
      serializer = PlaceSerializer.new place, include: %i[upcoming_events upcoming_events.user]
      render json: serializer.serializable_hash, status: :ok
    else
      render status: 404
    end
  end

  def update
    place = Place.find params[:id]
    ap safe_params
    if place.update!(safe_params)
      render json: PlaceSerializer.json_for(place)
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  private

  def safe_params
    params.require(:place).permit :description,
                                  images: []
  end
end
