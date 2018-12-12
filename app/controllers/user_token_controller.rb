class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token, only: %i[create]

  def auth_params
      params.permit :email, :password
    end
end
