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

# load .env
Dotenv.load

module CottageclassAppApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # CORS - allow requests from only our client domain
    config.middleware.use Rack::Cors do
      allow do
        origins 'https://localhost:8077',
          'https://app.cottageclass.com',
          'https://cottageclass-app-staging.herokuapp.com',
          'https://cottageclass-app.herokuapp.com',
          'https://192.168.1.4:8077',
          'https://192.168.1.12:3001',
          'https://twilio.com'

        resource '*',
          headers: :any,
          credentials: true,
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :put, :delete, :options]
      end
    end

    # eager load to view autoload_paths errors in development
    # - https://stackoverflow.com/questions/38198668/rails-5-load-lib-files-in-production
    # - can be turned off for dev/test if this slows them down
    #config.eager_load = true

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
