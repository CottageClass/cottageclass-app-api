require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Participant' do
  include_context 'json headers'

  let(:event) { create :event }
  let(:user) { create :user, :with_children }
  let(:subject) { build :participant, participable: event, user: user }

  post '/api/events/:event_id/participants', format: :json do
    parameter :event_id, 'Event Identifier', required: true

    let(:event_id) { event.id }

    context 'authorized' do
      include_context 'authorization token'

      example_request 'create:success' do
        expect(response_status).to eq(201)
      end

      context 'failure' do
        let(:event_id) { Faker::Number.number 2 }

        example 'create:failure', document: false do
          do_request
          expect(response_status).to eq(404)
        end
      end
    end

    context 'unauthorized' do
      example 'authentication:failure', document: false do
        do_request
        expect(response_status).to eq(401)
      end
    end
  end

  delete '/api/events/:event_id/participants', format: :json do
    include_context 'authorization token'

    before { subject.save }

    parameter :event_id, 'Event Identifier', required: true
    let(:event_id) { event.id }

    example_request 'destroy:success' do
      expect(response_status).to eq(200)
    end
  end
end
