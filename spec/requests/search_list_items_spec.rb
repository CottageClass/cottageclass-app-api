require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'User' do
  include_context 'json headers'
  let(:user) { create :user }

  get '/api/feed//miles/:miles/latitude/:latitude/longitude/:longitude', format: :json do
    parameter :miles, 'distance from centerpoint', required: true
    parameter :latitude, 'latitude of centerpoint', required: true
    parameter :longitude, 'longitude of centerpoint', required: true

    let(:miles) { 10 }
    let(:latitude) { user.latitude }
    let(:longitude) { user.longitude }
    example_request 'feed:success' do
      expect(response_status).to eq(200)
    end
  end

  get '/api/feed//miles/:miles/latitude/:latitude/longitude/:longitude/min_age/:min_age/max_age/:max_age/page/:page/page_size/:page_size', format: :json do
    parameter :miles, 'distance from centerpoint', required: true
    parameter :latitude, 'latitude of centerpoint', required: true
    parameter :longitude, 'longitude of centerpoint', required: true
    parameter :min_age, 'minimum age', required: false
    parameter :max_age, 'maximum age', required: false
    parameter :page, 'page number', required: false
    parameter :page_size, 'items per page', required: false

    let(:miles) { 10 }
    let(:latitude) { user.latitude }
    let(:longitude) { user.longitude }
    let(:min_age) { 2 }
    let(:max_age) { 9 }
    let(:page) { 1 }
    let(:page_size) { 1 }
    example_request 'feed:success' do
      expect(response_status).to eq(200)
    end
  end
end
