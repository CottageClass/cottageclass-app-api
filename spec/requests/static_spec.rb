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
end
