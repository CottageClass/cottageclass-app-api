require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Child' do
  include_context 'json headers'
  include_context 'authorization token'

  let(:user) { create :user, :with_children }
  let(:subject) { user.children.sample }

  put '/api/user/children/:id', format: :json do
    parameter :id, 'Child Identifier', required: true
    with_options scope: :child, with_example: true do
      parameter :emergency_contacts_attributes, 'Array of emergency contacts'
    end

    let(:id) { subject.id }
    let(:emergency_contacts) { build_list :emergency_contact, 1, contactable: subject }
    let :emergency_contacts_attributes do
      emergency_contacts.map do |instance|
        instance.attributes.with_indifferent_access.slice :name,
                                                          :phone_number,
                                                          :relationship,
                                                          :special_needs,
                                                          :allergies,
                                                          :dietary_restrictions
      end
    end

    example_request 'update:success' do
      expect(response_status).to eq(200)
    end
  end
end
