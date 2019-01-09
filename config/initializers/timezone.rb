Timezone::Lookup.config(:google) { |config| config.api_key = ENV.fetch 'GOOGLE_API_KEY' }
