class Users::PasswordsController < Devise::PasswordsController
  def create
    puts 'request_params'
    puts request_params
    self.resource = resource_class.send_reset_password_instructions(request_params)

    if successfully_sent?(resource)
      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: ['Error occurred'] }, status: :internal_server_error
    end
  end

  def update
    user = User.with_reset_password_token(password_params[:reset_password_token])
    if user&.update(password_params)
      render json: user, status: :ok
    else
      render json: { error: ['Password update failed'] }, status: :internal_server_error
    end
  end

  private

  def password_params
    params.require(:user).permit :password, :reset_password_token
  end

  def request_params
    params.require(:user).permit :email
  end
end
