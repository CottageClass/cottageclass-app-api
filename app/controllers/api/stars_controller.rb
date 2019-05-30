class API::StarsController < API::BaseController
  before_action :authenticate_user!

  def create
    star = Star.new giver: current_user, starable: @starable
    star.save
    render status: :created
  end

  def destroy
    star = Star.find_by giver: current_user.id,
                        starable_type: @starable.class.name,
                        starable_id: @starable.id
    if !star.nil?
      star.destroy
      render status: 204
    else
      render status: 404
    end
  end

  private

  def safe_params
    params.require(:user_id).permit :starable
  end
end
