# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins 'example.com'
#
#     resource '*',
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end
    # configure CORS to allow our client-side domain requests
    # - See: https://github.com/cyu/rack-cors#rails-configuration
    Rails.application.config.middleware.insert_before 0, Rack::Cors, debug: true do
      allow do
        #origins 'https://app.cottageclass.com', 'https://88f5065d.ngrok.io', 'http://localhost:8077', 'https://localhost:8077'
        origins 'https://localhost:3000', 'https://localhost:8077', 'https://facebook.com', 'cottageclass-app-api.herokuapp.com', 'cottageclass-map-vue.herokuapp.com'
        resource '*',
          headers: :any,
          credentials: true,
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :put, :delete, :options]
      end
    end
