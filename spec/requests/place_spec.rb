require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Place' do
  include_context 'json headers'

  context 'authorized' do
    include_context 'authorization token'

    let(:user) { create :user }
    let(:place) { create :place }

    with_options scope: :place, with_example: true do
      parameter :google_id, 'Google Places Id', required: true
      parameter :public, 'Reveal details to all users', required: true
    end

    post '/api/places', format: :json do
      let(:google_id) { 'UNIQUE_SOME_LONG_GOOGLE_STRING' }
      let(:public) { true }
      example_request 'update:success' do
        expect(response_status).to eq(201)
      end
    end
  end

  context 'unauthorized' do
    post '/api/places', format: :json do
      example_request 'update:success' do
        expect(response_status).to eq(401)
      end
    end
  end
end
