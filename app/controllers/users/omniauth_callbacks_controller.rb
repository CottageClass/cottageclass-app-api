class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: %i[facebook]

  def facebook
    # this will create a new user if it doesn't exist
    @user = User.from_omniauth request.env['omniauth.auth']
    sign_in_and_redirect @user, event: :authentication
  end
end
