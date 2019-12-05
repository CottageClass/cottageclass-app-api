require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'PlaceReviews' do
  include_context 'json headers'

  let(:user) { create :user }
  let(:place) { create :place }
  let(:place_id) { place.id }

  post '/api/places/:place_id/place_reviews', format: :json do
    parameter :place_id, 'Place id', required: true
    parameter :stars, 'Star count', required: true
    parameter :content, 'Review content', required: true

    context 'authorized' do
      include_context 'authorization token'
      let(:content) { 'nice place' }
      let(:stars) { 4 }

      example_request 'index:success' do
        expect(response_status).to eq(200)
      end
    end

    context 'unauthenticated' do
      example 'authentication:failure', document: false do
        do_request
        expect(response_status).to eq(401)
      end
    end

    context 'failure' do
      include_context 'authorization token'
      let(:place_id) { Faker::Number.number 2 }

      example 'index:failure', document: false do
        do_request
        expect(response_status).to eq(404)
      end
    end
  end

  get '/api/places/:place_id/place_reviews', format: :json do
    context 'success' do
      let(:place_id) { place.id }

      example_request 'index:success' do
        expect(response_status).to eq(200)
      end
    end

    context 'failure' do
      let(:place_id) { Faker::Number.number 2 }

      example 'index:failure', document: false do
        do_request
        expect(response_status).to eq(404)
      end
    end
  end
end
