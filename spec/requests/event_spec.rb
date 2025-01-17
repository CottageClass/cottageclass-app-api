require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Event' do
  include_context 'json headers'

  let(:user) { create :user, :with_children, :with_place }
  let(:place) { create :place }

  context 'index' do
    before do
      event_series = create_list :event_series, 5, user: user, place: place
      create_list(:user, 3, :with_children).each do |user|
        Event.where(event_series: event_series).find_each do |event|
          create :participant, participable: event, user: user
        end
      end
    end

    get '/api/places/:place_id/events/:skope/page/:page/page_size/:page_size', format: :json do
      let(:place_id) { place.id }
      let(:skope) { nil }
      let(:sort) { 'chronological' }
      [nil, 'past', 'upcoming'].each do |skope|
        name = skope || 'all'
        context name do
          let(:skope) { skope }

          example format('%s:success', name) do
            explanation 'returns events at a specific place with place_id'\
            ' :skope is optional '\
            ' :page and :page_size are optional parameters.'\
            ' If :page is omitted, the endpoint returns all records for the scope. Default value for :page_size is 10.'\
            ' Place is not optional'
            do_request
            expect(response_status).to eq(200)
          end
        end
      end
    end

    get '/api/events/:skope/miles/:miles/latitude/:latitude/longitude/:longitude/sort/:sort', format: :json do
      let(:skope) { nil }
      let(:miles) { 10 }
      let(:latitude) { user.place.latitude }
      let(:longitude) { user.place.longitude }
      let(:sort) { 'chronological' }

      [nil, 'past', 'upcoming'].each do |skope|
        name = skope || 'all'
        context name do
          let(:skope) { skope }

          example format('%s:success', name) do
            explanation ' :miles, :latitude, :longitude and :sort are optional parameters.'\
            ' If :miles is available, but :latitude or :longitude are not, tries using authenticated user\'s location.'\
            ' If :sort is chronological, results are sorted chronologically. Otherwise, results are sorted by distance.'
            do_request
            expect(response_status).to eq(200)
          end
        end
      end

      context 'authorized' do
        include_context 'authorization token'

        example 'authorized:success' do
          explanation 'Response to authenticated requests will contain the extra attribute: participated'
          do_request
          expect(response_status).to eq(200)
        end
      end
    end

    get '/api/events/:skope/miles/:miles/latitude/:latitude/longitude/:longitude', format: :json do
      let(:skope) { nil }
      let(:miles) { 10 }
      let(:latitude) { user.place.latitude }
      let(:longitude) { user.place.longitude }

      [nil, 'past', 'upcoming'].each do |skope|
        name = skope || 'all'
        context name do
          let(:skope) { skope }

          example format('%s:success', name), document: false do
            do_request
            expect(response_status).to eq(200)
          end
        end
      end
    end

    get '/api/events/:skope/page/:page/page_size/:page_size', format: :json do
      let(:skope) { nil }
      let(:page) { 1 }
      let(:page_size) { 10 }

      [nil, 'past', 'upcoming'].each do |skope|
        name = skope || 'all'
        context name do
          let(:skope) { skope }

          example format('%s:success', name), document: false do
            do_request
            expect(response_status).to eq(200)
          end
        end
      end
    end

    get '/api/users/:user_id/events/created/:skope/page/:page/page_size/:page_size', format: :json do
      let(:user_id) { user.id }
      let(:skope) { 'upcoming' }
      let(:page) { 1 }
      let(:page_size) { 10 }

      context 'authorized' do
        include_context 'authorization token'

        example 'created_events:success' do
          explanation 'Events created by user'
          do_request
          expect(response_status).to eq(200)
          expect(json_body.fetch('data', []).size).to eq(page_size)
        end
      end

      context 'unauthorized' do
        example 'created_events:success', document: false do
          do_request
          expect(response_status).to eq(200)
        end
      end
    end

    get '/api/users/:user_id/events/participated/:skope/page/:page/page_size/:page_size', format: :json do
      before do
        another_user = create :user
        event_series = create_list :event_series, 5, user: another_user, place: place
        Event.where(event_series: event_series).find_each do |event|
          create :participant, participable: event, user: user
        end
      end

      let(:user_id) { user.id }
      let(:skope) { 'upcoming' }
      let(:page) { 1 }
      let(:page_size) { 10 }

      context 'authorized' do
        include_context 'authorization token'

        example 'participated_events:success' do
          explanation 'Events participated by user'
          do_request
          expect(response_status).to eq(200)
          expect(json_body.fetch('data', []).size).to eq(page_size)
        end
      end

      context 'unauthorized' do
        example 'participated_events:forbidden', document: false do
          do_request
          expect(response_status).to eq(401)
        end
      end
    end

    get '/api/events/starred', format: :json do
      let(:event_series) { create :event_series }
      let(:other_event_series) { create :event_series }
      before do
        other_event_series
        user.stars.create starable: event_series
      end

      context 'authorized' do
        include_context 'authorization token'

        example 'starred_events:success' do
          explanation 'Events in series that have been starred by current user'
          do_request
          expect(response_status).to eq(200)
          expect(json_body.fetch('data', []).size).to eq(event_series.events.upcoming.count)
        end
      end

      context 'unauthorized' do
        example 'starred_events:unauthenticated', document: false do
          do_request
          expect(response_status).to eq(401)
        end
      end
    end
  end

  context 'member operations' do
    include_context 'authorization token'

    before do
      create_list(:user, 3, :with_children).each do |user|
        create :participant, participable: subject, user: user
      end
    end

    let(:event_series) { create :event_series, user: user }
    let(:subject) { event_series.events.sample }
    let(:id) { subject.id }

    get '/api/events/:id', format: :json do
      before do
        2.times do
          user_with_children = create :user, :with_children
          create :participant, participable: subject, user: user_with_children
        end
      end

      example_request 'show:success' do
        expect(response_status).to eq(200)
      end

      context 'failure' do
        let(:id) { Faker::Number.between 100, 200 }

        example 'show:not_found', document: false do
          do_request
          expect(response_status).to eq(404)
        end
      end
    end

    context 'destroy' do
      delete '/api/events/:id', format: :json do
        example_request 'destroy:success' do
          expect(response_status).to eq(200)
        end

        example 'destroy:forbidden', document: false do
          event_series.update user: create(:user)
          do_request
          expect(response_status).to eq(403)
        end
      end
    end

    context 'update' do
      with_options scope: :event, with_example: true do
        parameter :name, 'Name', required: true
        parameter :starts_at, 'Start Time', required: true
        parameter :ends_at, 'End Time', required: true
        parameter :child_age_minimum, 'Minimum age of child. Default: 0 (no limit)'
        parameter :child_age_maximum, 'Maximum age of child. Default: 0 (no limit)'
      end

      %i[
        name
        child_age_minimum
        child_age_maximum
      ].each do |attribute|
        let(attribute) { subject.send attribute }
      end
      %i[starts_at ends_at].each { |attribute| let(attribute) { subject.send(attribute).to_s :rfc2822 } }

      put '/api/events/:id', format: :json do
        example_request 'update:success' do
          expect(response_status).to eq(200)
        end

        example 'update:forbidden', document: false do
          event_series.update user: create(:user)
          do_request
          expect(response_status).to eq(403)
        end
      end
    end
  end
end
