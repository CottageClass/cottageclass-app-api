class Users::SessionsController < Devise::SessionsController
  # protect_from_forgery with: :null_session # since this is called as an API, we have to deal with CSRF tokens
  skip_before_action :verify_authenticity_token, only: %i[destroy create]

  respond_to :json

  def sign_in_params
    params.require(:user).permit :email, :password
  end

  def respond_with(resource, _opts = {})
    render json: Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)
  end

  def respond_to_on_destroy
    head :no_content
  end
end
