require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'User' do
  include_context 'json headers'

  let(:user) { build :user, :with_children, :with_place }
  let(:other_user) { build :user, :with_children, :with_place }

  context 'read operations' do
    before { user.save }

    before { other_user.save }

    let(:id) { user.id }
    let(:other_user_id) { other_user.id }

    get '/api/users/miles/:miles/latitude/:latitude/longitude/:longitude/min_age/:min_age/max_age/:max_age/page/:page/page_size/:page_size',
        format: :json do
      include_context 'authorization token'

      let(:miles) { 10 }
      let(:latitude) { user.place.latitude }
      let(:longitude) { user.place.longitude }
      let(:page) { 1 }
      let(:min_age) { 3 }
      let(:max_age) { 5 }
      let(:page_size) { 10 }

      example_request 'nearby:success' do
        expect(response_status).to eq(200)
        expect(json_body.fetch('data', []).map { |u| u.dig('attributes', 'phone') }.compact).to be_blank
      end
    end

    context 'authenticated' do
      include_context 'authorization token'

      post '/api/users/:other_user_id/stars', format: :json do
        example_request 'authenticated stars' do
          expect(response_status).to eq(201)
        end
      end
      delete '/api/users/:other_user_id/stars', format: :json do
        example_request 'authenticated stars' do
          expect(response_status).to eq(404)
        end
      end

      get '/api/users/:id', format: :json do
        example_request 'get self' do
          included_children = json_body.dig('included')
          included_children.select { |object| object[:type] == 'child' }

          expect(response_status).to eq(200)
          expect(json_body.dig('data', 'attributes', 'phone_number')).to eq(user.phone_number)
          expect(json_body.dig('data', 'attributes', 'facebook_access_token')).to be_nil
          expect(json_body.dig('data', 'attributes', 'last_name')).not_to be_nil
          expect(json_body.dig('data', 'relationships', 'children')).not_to be_nil
          expect(included_children.map { |u| u.dig('attributes', 'age_in_months') }.compact).not_to be_blank
          expect(included_children.map { |u| u.dig('attributes', 'birthday') }.compact).not_to be_blank
        end
      end
      get '/api/users/:other_user_id', format: :json do
        example_request 'get other user' do
          included_children = json_body.dig('included')
          included_children.select { |object| object[:type] == 'child' }

          expect(response_status).to eq(200)
          expect(json_body.dig('data', 'attributes', 'phone')).to be_nil
          expect(json_body.dig('data', 'attributes', 'last_name')).to be_nil
          expect(json_body.dig('data', 'relationships', 'children')).not_to be_nil
          expect(included_children.map { |u| u.dig('attributes', 'age_in_months') }.compact).not_to be_blank
          expect(included_children.map { |u| u.dig('attributes', 'birthday') }.compact).to be_blank
        end
      end
      delete '/api/users/:id', format: :json do
        example_request 'authenticated user deletion' do
          expect(response_status).to eq(200)
        end
      end
    end

    context 'unauthenticated' do
      delete '/api/users/:id/stars', format: :json do
        example_request 'unauthenticated stars' do
          expect(response_status).to eq(401)
        end
      end
      post '/api/users/:id/stars', format: :json do
        example_request 'unauthenticated stars' do
          expect(response_status).to eq(401)
        end
      end
      get '/api/users/:id', format: :json do
        example_request 'unauthenticated get' do
          expect(response_status).to eq(200)
          expect(json_body.dig('data', 'attributes').deep_symbolize_keys.keys).to \
            contain_exactly(*User::PUBLIC_ATTRIBUTES + %i[last_initial starred dark_starred])
        end
      end
      delete '/api/users/:id', format: :json do
        example_request 'user deletion' do
          expect(response_status).to eq(401)
        end
      end
    end
  end

  context 'write operations' do
    put 'api/users/:id', format: :json do
      include_context 'authorization token'

      with_options scope: :user do
        parameter :avatar, 'Avatar URL'
        parameter :images, 'Array of images'
        parameter :languages, 'Array of language codes'
        parameter :job_position, 'Job Title'
        parameter :employer, 'Employer'
        parameter :highest_education, 'Degree'
        parameter :school, 'School'
        parameter :instagram_user, 'Instagram user name'
        parameter :twitter_user, 'Twitter user name'
        parameter :linkedin_user, 'LinkedIn user name'
        parameter :referrer, 'Referrer'
        parameter :source_tags, 'Source tags'
        parameter :children_attributes, 'Array of children. Set _destroy to 1 to remove a child. Supply id to update.'
      end

      let(:user) { create :user, :with_children, :with_place }
      let(:id) { user.id }
      let(:user_data) { build :user, :with_children, :with_place }

      let(:avatar) { user_data.avatar }
      let(:images) { user_data.images }
      let(:languages) { user_data.languages }
      let(:job_position) { user_data.job_position }
      let(:employer) { user_data.employer }
      let(:highest_education) { user_data.highest_education }
      let(:school) { user_data.school }
      let(:instagram_user) { user_data.instagram_user }
      let(:twitter_user) { user_data.twitter_user }
      let(:linkedin_user) { user_data.linkedin_user }
      let(:referrer) { user_data.referrer }
      let(:source_tags) { user_data.source_tags }
      let :children_attributes do
        (user.children + user_data.children).map.with_index do |child, index|
          child_attributes = child.attributes.with_indifferent_access.slice :first_name,
                                                                            :birthday,
                                                                            :school_name,
                                                                            :allergies,
                                                                            :dietary_restrictions,
                                                                            :special_needs
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
