require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Event' do
  include_context 'json headers'

  let(:user) { create :user, :with_children }

  context 'read operations' do
    before { create :event_series, :with_event_hosts, user: user }

    get '/api/events/:skope', format: :json do
      let(:skope) { nil }

      [nil, 'past', 'upcoming'].each do |skope|
        name = skope || 'all'
        context name do
          let(:skope) { skope }

          example_request format('%s:success', name) do
            expect(response_status).to eq(200)
          end
        end
      end
    end
  end
end
