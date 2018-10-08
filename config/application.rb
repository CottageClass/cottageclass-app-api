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
    config.action_dispatch.default_headers = {
      "Access-Control-Allow-Origin" => "https://localhost:3000, https://localhost:8077, https://facebook.com, cottageclass-app-api.herokuapp.com, cottageclass-map-vue.herokuapp.com",
      "Access-Control-Request-Method" => "*",
      "Access-Control-Allow-Methods" => "POST, PUT, DELETE, GET, OPTIONS",
      "Access-Control-Allow-Headers" => "Origin, X-Requested-With, Content-Type, Accept, Authorization",
      "Access-Control-Expose-Headers" => "Access-Token, Expiry, Token-Type, uid, UID, Client",
      "Access-Control-Max-Age" => "[masked]",
      "X-Frame-Options" => "ALLOW_FROM https://localhost:8077",
      "Content-Security-Policy" => "frame-ancestors facebook.com"
    }

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
