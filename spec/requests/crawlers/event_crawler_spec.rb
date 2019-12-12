require 'rails_helper'

RSpec.describe 'static assets', type: :request do
  context 'facebook user agent crawler' do
    headers = { 'HTTP_USER_AGENT' => 'facebookexternalhit/1.1' }

    it 'returns the rendered pages with metadata for the facebook crawler' do
      event = create :event
      get '/event/' + event.id.to_s, headers: headers
      expect(response.body).to include event.name
    end

    context 'images' do
      default_event_image = 'https://storage.googleapis.com/cottageclass-prod/images/lilypad-youre-invited-to-a-playdate.png'
      let(:event) { create :event, :with_place }

      it 'returns the default image' do
        get '/event/' + event.id.to_s, headers: headers
        expect(response.body).to include default_event_image
      end

      it 'returns first event image if available' do
        event.images = [Faker::LoremPixel.image]
        event.save!
        get '/event/' + event.id.to_s, headers: headers
        expect(response.body).to include event.images[0]
      end

      it 'returns first place image if available' do
        event.place.images = [Faker::LoremPixel.image]
        event.place.save!
        get '/event/' + event.id.to_s, headers: headers
        expect(response.body).to include event.place.images[0]
      end
    end
  end
end
