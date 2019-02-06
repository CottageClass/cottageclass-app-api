module Mocks
  class Geocode < Mocks::Common
    def geocode_address(timeout: false)
      stub_api_request method: :get,
                       path: '[^.]+maps.googleapis.com/maps/api/geocode/.+',
                       params: {
                         headers: {
                           'Accept' => '*/*'
                         }
                       }, response: {
                         status: 200,
                         headers: {
                         },
                         body: {
                           results: [
                             {
                               address_components: [
                                 {
                                   long_name: '30',
                                   short_name: '30',
                                   types: ['street_number']
                                 },
                                 {
                                   long_name: 'Johnny Cake Hollow Road',
                                   short_name: 'Johnny Cake Hollow Rd',
                                   types: ['route']
                                 },
                                 {
                                   long_name: 'Pine Plains',
                                   short_name: 'Pine Plains',
                                   types: %w[locality political]
                                 },
                                 {
                                   long_name: 'Pine Plains',
                                   short_name: 'Pine Plains',
                                   types: %w[administrative_area_level_3 political]
                                 },
                                 {
                                   long_name: 'Dutchess County',
                                   short_name: 'Dutchess County',
                                   types: %w[administrative_area_level_2 political]
                                 },
                                 {
                                   long_name: 'New York',
                                   short_name: 'NY',
                                   types: %w[administrative_area_level_1 political]
                                 },
                                 {
                                   long_name: 'United States',
                                   short_name: 'US',
                                   types: %w[country political]
                                 },
                                 {
                                   long_name: '12567',
                                   short_name: '12567',
                                   types: ['postal_code']
                                 },
                                 {
                                   long_name: '5802',
                                   short_name: '5802',
                                   types: ['postal_code_suffix']
                                 }
                               ],
                               formatted_address: '30 Johnny Cake Hollow Rd, Pine Plains, NY 12567, USA',
                               geometry: {
                                 location: {
                                   lat: 41.963752,
                                   lng: -73.614414
                                 },
                                 location_type: 'ROOFTOP',
                                 viewport: {
                                   northeast: {
                                     lat: 41.9651009802915,
                                     lng: -73.6130650197085
                                   },
                                   southwest: {
                                     lat: 41.9624030197085,
                                     lng: -73.6157629802915
                                   }
                                 }
                               },
                               place_id: 'ChIJCTp_RFp43YkRblyM-VdlJJ8',
                               plus_code: {
                                 compound_code: 'X97P+G6 Pine Plains, NY, United States',
                                 global_code: '87H8X97P+G6'
                               },
                               types: ['street_address']
                             }
                           ],
                           status: 'OK'
                         }
                       },
                       timeout: timeout
    end
  end
end

RSpec.configure do |config|
  config.before { Mocks::Geocode.new.geocode_address }
end
