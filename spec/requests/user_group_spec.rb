require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'UserGroup' do
  include_context 'json headers'

  let(:user) { create :user, :with_place }
  let(:group) { create :user_group }

  get '/api/user_groups/:id', format: :json do
    parameter :id, 'Group id', required: true

    let(:id) { group.id }

    context 'authorized' do
      let(:user) do
        user = create :user, :with_place
        user.user_groups << group
        user.save
        user
      end

      include_context 'authorization token'

      example_request 'index:success' do
        expect(response_status).to eq(200)
      end

      context 'failure' do
        let(:id) { Faker::Number.number 2 }

        example 'index:failure', document: false do
          do_request
          expect(response_status).to eq(404)
        end
      end
    end

    context 'unauthorized' do
      include_context 'authorization token'
      example 'authorization:failure', document: false do
        do_request
        expect(response_status).to eq(401)
      end
    end

    context 'unauthenticated' do
      example 'authentication:failure', document: false do
        do_request
        expect(response_status).to eq(401)
      end
    end
  end
end
