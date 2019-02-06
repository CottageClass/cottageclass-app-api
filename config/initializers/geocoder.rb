# See https://github.com/alexreisner/geocoder/blob/master/lib/geocoder/configuration.rb for all options

Geocoder.configure lookup: :google, api_key: ENV.fetch('GOOGLE_API_KEY')
