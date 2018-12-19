require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'EventSeries' do
  include_context 'json headers'

  let(:user) { build :user }
  let(:subject) { build :event_series }

  post api_event_series_index_path, format: :json do
    before { user.save }

    parameter :event_series, 'Event series data'
    let(:event_series) { subject }

    context 'authorized' do
      include_context 'authorization token'

      example_request 'create:success' do
        Utils.log response_body
        expect(response_status).to eq(201)
      end
    end

    context 'unauthorized' do
      example_request 'authentication:failure', document: false do
        expect(response_status).to eq(401)
      end
    end
  end
end
