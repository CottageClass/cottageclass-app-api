class API::StarsController < API::BaseController
  before_action :authenticate_user!, only: %i[create destroy]

  def create
    star = Star.new giver: current_user, starable: @starable
    star.save
    render_starable status: :created
  end

  def destroy
    star = Star.find_by giver: current_user.id,
                        starable_type: @starable.class.name,
                        starable_id: @starable.id
    if !star.nil?
      star.destroy
      render_starable status: 200
    else
      render status: 404
    end
  end

  def index
    givers = @starable.starrers
    serializer = PublicUserSerializer.new givers, params: { current_user: current_user }
    render json: serializer.serializable_hash, status: :ok
  end

  private

  def safe_params
    params.require(:user_id).permit :starable
  end
end
