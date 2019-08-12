class API::Users::DarkStarsController < ApiController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_recipient, only: %i[create destroy]

  def create
    dark_star = DarkStar.new giver: current_user, recipient: @recipient
    dark_star.save
    render_recipient
  end

  def destroy
    dark_star = DarkStar.find_by giver: current_user.id,
                                 recipient: @recipient
    if !dark_star.nil?
      dark_star.destroy
      render_recipient
    else
      render status: 404
    end
  end

  private

  def render_recipient
    serializer = PublicUserSerializer.new @recipient,
                                          include: %i[children],
                                          params: { current_user: current_user }
    render json: serializer.serializable_hash, status: 200
  end

  def set_recipient
    @recipient = User.find(params.require(:user_id))
  end
end
