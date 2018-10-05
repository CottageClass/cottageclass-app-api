require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CottageclassAppApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # TODO: ALTERNATIVE TO RACK-CORS
    # - https://www.meetup.com/NYC-rb/messages/77281438/
    # - TRY to use to get past FACEBOOK ORIGINULL CSRF error
    # - and allow to use just GET /auth/facebook and do entire OAuth flow the DTA way
    # - otherwise everything works!
    # - TODO: just need FE route to store the token at :8077/auth/callback
    #
    #   config.action_dispatch.default_headers = {
    #     "Access-Control-Allow-Origin" => "*",
    #     "Access-Control-Request-Method" => "*",
    #     "Access-Control-Allow-Methods" => "POST, PUT, DELETE, GET, OPTIONS",
    #     "Access-Control-Allow-Headers" => "Origin, X-Requested-With, Content-Type, Accept, Authorization",
    #     "Access-Control-Max-Age" => "[masked]",
    #     "X-Frame-Options" => "http://localhost"
    #   }

    # configure CORS to allow our client-side domain requests
    # - See: https://github.com/cyu/rack-cors#rails-configuration
    config.middleware.use Rack::Cors, debug: true do
      allow do
        #origins 'https://app.cottageclass.com', 'https://88f5065d.ngrok.io', 'http://localhost:8077', 'https://localhost:8077'
        origins 'localhost:3000', 'localhost:8077', 'facebook.com', 'cottageclass-app-api.herokuapp.com', 'cottageclass-map-vue.herokuapp.com'
        resource '*',
          headers: :any,
          credentials: true,
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :put, :delete, :options]
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # add in Session middleware for OmniAuth to work
    # - something about redirects not being handled properly without sessions
    # - See: https://github.com/lynndylanhurley/devise_token_auth/issues/183
    # - See: https://github.com/omniauth/omniauth#integrating-omniauth-into-your-rails-api
    config.session_store :cookie_store, key: '_interslice_session', domain: :all
    config.middleware.use ActionDispatch::Cookies # Required for all session management
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
  end
end
