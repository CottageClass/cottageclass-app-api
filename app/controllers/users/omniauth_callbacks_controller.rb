module Users
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    include Devise::Controllers::Rememberable

    def omniauth_success
      Rails.logger.info "IN OMNIAUTH SUCCESS"
      super
    end

    def auth_origin_url
      ENV['OAUTH_RECEIVE_TOKEN_ENDPOINT'] || 'https://localhost:8077/auth/callback'
    end

    # We are overriding this method to allow us to access /auth/facebook/callbacks directly.
    # - Copy some functionality over from https://github.com/lynndylanhurley/devise_token_auth/blob/master/app/controllers/devise_token_auth/omniauth_callbacks_controller.rb#L11
    # - to allow omniauth_success to have intended parameters
    def redirect_callbacks
      # preserve omniauth info for success route. ignore 'extra' in twitter
      #   auth response to avoid CookieOverflow.
      session['dta.omniauth.auth'] = request.env['omniauth.auth'].except('extra')
      session['dta.omniauth.params'] = request.env['omniauth.params']

      omniauth_success
    end

    protected

    # override as we only have a single user
    def resource_class
      'User'.constantize
    end
  end
end
