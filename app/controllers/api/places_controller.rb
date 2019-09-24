class API::PlacesController < API::BaseController
  before_action :authenticate_user!

  def create
    place = current_user.places.build safe_params

    if place.save!
      serializer = PlaceSerializer.new place
      render json: serializer.serializable_hash, status: :created
    else
      render json: { errors: place.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def safe_params
    params.require(:place).permit :google_id, :public
  end
end
