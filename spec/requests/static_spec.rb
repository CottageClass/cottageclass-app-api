require 'rails_helper'

RSpec.describe 'static assets', type: :request do
  it 'returns the SPA' do
    get '/'
    expect(response).to have_http_status(:success)
  end

  it 'returns the SPA for normal user agent' do
    event = create :event
    get '/event/' + event.id.to_s
    expect(response.body).to_not include event.name
  end

  it 'returns the rendered pages with metadata for the facebook crawler' do
    event = create :event
    headers = {
      'HTTP_USER_AGENT' => 'facebookexternalhit/1.1'
    }
    get '/event/' + event.id.to_s, headers: headers
    expect(response.body).to include event.name
  end
end
