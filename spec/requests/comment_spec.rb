require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Comment' do
  include_context 'json headers'

  let(:user) { create :user, :with_place }
  let(:group) { create :user_group }
  let(:subject) { build :comment, sender: user, group: group }

  get '/api/user_group/:user_group_id/comments', format: :json do
    parameter :user_group_id, 'Group id', required: true

    let(:user_group_id) { group.id }

    context 'authorized' do
      let(:user) do
        user = build :user, :with_place
        user.user_groups << group
        user.save
        user
      end

      include_context 'authorization token'

      example_request 'index:success' do
        expect(response_status).to eq(200)
      end

      context 'failure' do
        let(:user_group_id) { Faker::Number.number 2 }

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

  post '/api/user_group/:user_group_id/comments', format: :json do
    parameter :user_group_id, 'Group id', required: true
    with_options scope: :comment, with_example: true do
      parameter :content, 'Content', required: true
    end

    let(:content) { subject.content }

    let(:user_group_id) { group.id }

    context 'authorized' do
      include_context 'authorization token'
      let(:user) do
        user = build :user, :with_place
        user.user_groups << group
        user.save
        user
      end

      example_request 'create:success' do
        expect(response_status).to eq(201)
      end

      context 'failure' do
        let(:user_group_id) { Faker::Number.number 2 }

        example 'create:failure', document: false do
          do_request
          expect(response_status).to eq(404)
        end
      end
    end

    context 'unauthenticated' do
      example 'authentication:failure', document: false do
        do_request
        expect(response_status).to eq(401)
      end
    end

    context 'unauthorized' do
      include_context 'authorization token'
      example 'authorization:failure', document: false do
        do_request
        expect(response_status).to eq(401)
      end
    end
  end
end
