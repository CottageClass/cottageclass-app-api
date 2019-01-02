# Timezone::Lookup.config(:google) { |c| c.api_key = ENV.fetch 'GOOGLE_API_KEY' }
Timezone::Lookup.config(:geonames) { |c| c.username = ENV.fetch('GEONAMES_USERNAME') }
