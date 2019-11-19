require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Child' do
  include_context 'json headers'
  include_context 'authorization token'

  let(:user) { create :user, :with_children }
  let(:subject) { user.children.sample }

  put '/api/user/children/:id', format: :json do
    parameter :id, 'Child Identifier', required: true

    let(:id) { subject.id }

    example_request 'update:success' do
      expect(response_status).to eq(200)
    end
  end
end
