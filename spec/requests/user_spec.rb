require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'User' do
  include_context 'json headers'

  let(:user) { build :user, :with_children, :with_user_reviews }

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
        parameter :images, 'Array of images'
        parameter :languages, 'Array of language codes'
        parameter :job_position, 'Job Title'
        parameter :employer, 'Employer'
        parameter :highest_education, 'Degree'
        parameter :school, 'School'
        parameter :instagram_user, 'Instagram user name'
        parameter :twitter_user, 'Twitter user name'
        parameter :linkedin_user, 'LinkedIn user name'
        parameter :children_attributes, 'Array of children. Set _destroy to 1 to remove a child. Supply id to update.'
      end

      let(:user) { create :user, :with_children }
      let(:id) { user.id }
      let(:user_data) { build :user, :with_children }

      let(:avatar) { user_data.avatar }
      let(:apartment_number) { user_data.apartment_number }
      let(:images) { user_data.images }
      let(:languages) { user_data.languages }
      let(:job_position) { user_data.job_position }
      let(:employer) { user_data.employer }
      let(:highest_education) { user_data.highest_education }
      let(:school) { user_data.school }
      let(:instagram_user) { user_data.instagram_user }
      let(:twitter_user) { user_data.twitter_user }
      let(:linkedin_user) { user_data.linkedin_user }
      let :children_attributes do
        (user.children + user_data.children).map.with_index do |child, index|
          child_attributes = child.attributes.with_indifferent_access.slice :first_name, :birthday, :school_name
          child_attributes.update(id: child.id) if child.persisted?
          child_attributes.update(_destroy: 1) if index.zero?
          child_attributes
        end
      end

      example_request 'update:success' do
        expect(response_status).to eq(200)
      end
    end
  end
end
