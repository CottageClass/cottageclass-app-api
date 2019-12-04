class API::PlaceReviewsController < API::BaseController
  before_action :authenticate_user!, only: :create
  before_action :load_place

  def index
    serializer = PlaceReviewSerializer.new @place.place_reviews,
                                           include: %i[user],
                                           params: { skip_children: true }
    render json: serializer.serializable_hash, status: :ok
  end

  def create
    @place.place_reviews.create safe_params
    serializer = PlaceReviewSerializer.new @place.place_reviews,
                                           include: %i[user],
                                           params: { skip_children: true }
    render json: serializer.serializable_hash, status: :ok
  end

  private

  def safe_params
    params.require(:place_review).permit(:stars, :content).to_h.update(user: current_user)
  end

  def load_place
    @place = Place.find_by id: params[:place_id] if params[:place_id].present?
    render(json: {}, status: :not_found) if @place.blank?
  end
end
