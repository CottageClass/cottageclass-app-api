class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  # add forgery protection back in since OmniAuth uses sessions
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session, if: -> {request.format.json?}

  # TODO: need set up CallbacksController as in: https://github.com/leikir/devise-token-auth-omniauth-example/commit/9bc9238899e9dcdf1d1cb9dff448689196102cea
  # TODO: send CSRF token from frontend eg w axios: https://github.com/leikir/devise-token-auth-omniauth-example/commit/287a13fcb7a4a74411ab8168ce900fb63e0e0376
  #
end
