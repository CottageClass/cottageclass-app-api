require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Notification' do
  include_context 'json headers'

  let(:user) { create :user }
  let(:subject) { build :notification, recipient: user }

  post '/api/users/:user_id/notifications', format: :json do
    parameter :user_id, 'User Identifier', required: true
    with_options scope: :notification do
      parameter :body, 'Notification Body', required: true
    end

    let(:user_id) { user.id }
    let(:body) { subject.body }

    context 'authorized' do
      include_context 'authorization token'

      example_request 'create:success' do
        expect(response_status).to eq(201)
      end

      context 'failure' do
        let(:body) { nil }

        example 'create:failure', document: false do
          do_request
          expect(response_status).to eq(422)
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
