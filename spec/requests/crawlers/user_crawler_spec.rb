require 'rails_helper'

RSpec.describe 'static assets', type: :request do
  context 'facebook user agent crawler' do
    headers = { 'HTTP_USER_AGENT' => 'facebookexternalhit/1.1' }

    let (:user) { create :user }

    context 'content' do
      it 'returns user avatar' do
        get '/users/' + user.id.to_s, headers: headers
        expect(response.body).to include user.avatar.sub '&', '&amp;'
        expect(response.body).to include "Plan a playdate with #{user.first_name} on Lilypad"
      end
    end
  end
end
