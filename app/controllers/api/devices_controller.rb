class API::DevicesController < API::BaseController
  before_action :authenticate_user!

  def create
    device = current_user.devices.build safe_params
    if device.save
      render status: :created
    else
      render json: { errors: device.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def safe_params
    params.require(:device).permit :token, :platform
  end
end
