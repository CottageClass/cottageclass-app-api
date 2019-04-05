require_relative './common.rb'

module Mocks
  class Timezone < Mocks::Common
    def time_zone_for(timeout: false)
      stub_api_request method: :get,
                       path: '[^.]+maps.googleapis.com/maps/api/timezone/.+',
                       params: {
                         headers: {
                           'Accept' => '*/*'
                         }
                       }, response: {
                         status: 200,
                         headers: {
                         },
                         body: {
                           dstOffset: 0,
                           rawOffset: -18_000,
                           status: 'OK',
                           timeZoneId: 'America/New_York',
                           timeZoneName: 'Eastern Standard Time'
                         }
                       },
                       timeout: timeout
    end
  end
end

RSpec.configure do |config|
  config.before { Mocks::Timezone.new.time_zone_for }
end
