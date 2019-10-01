class API::PlacesController < API::BaseController
  before_action :authenticate_user!

  def create
    place = current_user.created_places.build safe_params
    existing_record = Place.find_by google_id: place.google_id
    if existing_record.nil?
      if place.save!
        serializer = PlaceSerializer.new place
        render json: serializer.serializable_hash,
               status: :created
      else
        render json: { errors: place.errors.full_messages },
               status: 200
      end
    else
      serializer = PlaceSerializer.new existing_record
      render json: serializer.serializable_hash,
             status: :created
    end
  end

  private

  def safe_params
    params.require(:place).permit :google_id, :public
  end
end
