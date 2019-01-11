class API::NotificationsController < API::BaseController
  before_action :authenticate_user, :verify_user

  def create
    notification = user.notifications.build safe_params
    if notification.save
      render json: NotificationSerializer.new(notification).serializable_hash, status: :created
    else
      render json: { errors: notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def verify_user
    render(json: {}, status: :not_found) if user.blank?
  end

  def user
    User.find_by id: params[:user_id]
  end

  def safe_params
    params.require(:notification).permit :body
  end
end
