require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Event' do
  include_context 'json headers'

  let(:user) { create :user }

  context 'read operations' do
    before { create :event_series, :with_event_hosts, user: user }

    get api_events_path, format: :json do
      context 'authorized' do
        include_context 'authorization token'

        example_request 'index:success' do
          expect(response_status).to eq(200)
        end
      end

      context 'unauthorized' do
        example 'authentication:failure', document: false do
          do_request
          expect(response_status).to eq(401)
        end
      end
    end
  end
end
