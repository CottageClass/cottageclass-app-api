require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'User' do
  include_context 'json headers'

  let(:user) { build :user, :with_children }

  context 'read operations' do
    before { user.save }

    get '/networks/:network_code/users', format: :json do
      include_context 'authorization token'
      let(:network_code) { user.network_code }

      example_request 'index:success' do
        expect(response_status).to eq(200)
        expect(json_body.fetch('data', []).map { |u| u.dig('attributes', 'phone') }.compact).to be_blank
      end
    end

    get '/users/:id', format: :json do
      let(:id) { user.id }

      context 'authorized' do
        include_context 'authorization token'

        example_request 'show:success' do
          expect((json_body.dig('included') || []).map { |included| included.dig('attributes', 'first_name') }.compact)
            .not_to be_blank
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

    post '/users/:id', format: :json do
      include_context 'authorization token'

      with_options scope: :user do
        parameter :avatar, 'Avatar URL'
        parameter :apartment_number, 'Apartment Number'
        parameter :children_attributes, 'Array of children'
      end

      let(:user) { create :user }
      let(:id) { user.id }
      let(:user_data) { build :user, :with_children }
      let(:avatar) { user_data.avatar }
      let(:apartment_number) { user_data.apartment_number }
      let :children_attributes do
        user_data.children.map do |child|
          child.attributes.with_indifferent_access.slice :first_name,
                                                         :birthday,
                                                         :school_name,
                                                         :emergency_contact_name,
                                                         :emergency_contact_phone_number,
                                                         :emergency_contact_relationship,
                                                         :allergies,
                                                         :dietary_restrictions,
                                                         :special_needs
        end
      end

      example_request 'update:success' do
        expect(response_status).to eq(200)
      end
    end
  end
end
