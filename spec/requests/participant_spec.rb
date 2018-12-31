require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Participant' do
  include_context 'json headers'

  let(:event) { create :event }
  let(:user) { create :user, :with_children }
  let(:subject) { build :participant, participable: event_series, user: user }

  post '/api/events/:event_id/participants', format: :json do
    parameter :event_id, 'Event Identifier', required: true
    with_options scope: :participant do
      parameter :participant_children_attributes, 'Participant children attributes', required: true
    end

    let(:event_id) { event.id }
    let :participant_children_attributes do
      user.children.take(1).map { |child| { child_id: child.id } }
    end

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
end
