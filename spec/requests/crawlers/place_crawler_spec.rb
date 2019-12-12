require 'rails_helper'

RSpec.describe 'static assets', type: :request do
  context 'facebook user agent crawler' do
    headers = { 'HTTP_USER_AGENT' => 'facebookexternalhit/1.1' }

    it 'returns rendered public place page' do
      place = create :place
      get '/places/' + place.id.to_s, headers: headers
      expect(response.body).to include place.name
    end

    it 'returns 404 for private place' do
      place = create :place, public: false
      get '/places/' + place.id.to_s, headers: headers
      expect(response.status).to eq(404)
    end

    context 'images' do
      default_event_image = 'https://storage.googleapis.com/cottageclass-prod/images/lilypad-youre-invited-to-a-playdate.png'
      let(:place) { create :place }

      it 'returns the default image' do
        get '/places/' + place.id.to_s, headers: headers
        expect(response.body).to include default_event_image
      end
      it 'returns first place image if available' do
        place.images = [Faker::LoremPixel.image]
        place.save!
        get '/places/' + place.id.to_s, headers: headers
        expect(response.body).to include place.images[0]
      end
    end
  end
end
