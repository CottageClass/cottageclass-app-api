class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: %i[destroy]

  respond_to :json

  def sign_in_params
    params.require(:user).permit :email, :password
  end

  def respond_with(resource, _opts = {})
    render json: UserSerializer.new(resource).serialized_json, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end
