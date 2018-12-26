require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'User' do
  include_context 'json headers'

  let(:user) { create :user, :with_children }

  context 'read operations' do
    get '/users/:id', format: :json do
      let(:id) { user.id }

      context 'authorized' do
        include_context 'authorization token'

        example_request 'show:success' do
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
