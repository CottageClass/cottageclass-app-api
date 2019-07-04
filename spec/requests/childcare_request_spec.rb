require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'ChildcareRequest' do
  include_context 'json headers'
  let(:user) { create :user }
  let(:subject) { create :childcare_request }

  context 'authenticated' do
    include_context 'authorization token'

    delete 'api/childcare_requests/:id', format: :json do
      before { subject.save }

      let(:id) { subject.id }
      example 'delete:failure' do
        do_request
        expect(response_status).to eq(200)
      end
    end

    post api_childcare_requests_path, format: :json do
      with_options scope: :childcare_request do
        parameter :content, 'The content of the childcare requst', required: true
      end
      let(:content) { subject.content }

      example 'create:success' do
        do_request
        expect(response_status).to eq(201)
      end
    end
  end

  context 'unauthenticated' do
    parameter :id, 'Unique Identifier', required: true
    let(:id) { subject.id }

    delete 'api/childcare_requests/:id', format: :json do
      example 'delete:failure' do
        do_request
        expect(response_status).to eq(401)
      end
    end

    post api_childcare_requests_path, format: :json do
      example 'create:failure' do
        do_request
        expect(response_status).to eq(401)
      end
    end

    get 'api/childcare_requests/:id', format: :json do
      example 'show:success' do
        do_request
        expect(response_status).to eq(200)
        expect(json_body.dig('data', 'attributes', 'content')).to eq(subject.content)
      end
    end
  end
end
