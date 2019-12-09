require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'EventSeries' do
  include_context 'json headers'

  let(:user) { create :user }
  let(:subject) { build :event_series, user: user }

  context 'write operations' do
    with_options scope: :event_series, with_example: true do
      parameter :name, 'Name', required: true
      parameter :start_date, 'Start Date', required: true
      parameter :starts_at, 'Start Time', required: true
      parameter :ends_at, 'End Time', required: true
      parameter :place, 'Place'
      parameter :child_age_minimum, 'Minimum age of child. Default: 0 (no limit)'
      parameter :child_age_maximum, 'Maximum age of child. Default: 0 (no limit)'
      parameter :repeat_for, 'Number of events this series. Default: 6'
      parameter :interval, 'Interval in weeks between events. Default: 4'
    end

    %i[
      name
      start_date
      child_age_minimum
      child_age_maximum
      repeat_for
      interval
    ].each do |attribute|
      let(attribute) { subject.send attribute }
    end

    %i[starts_at ends_at].each { |attribute| let(attribute) { subject.send(attribute).to_s :time } }

    post api_event_series_index_path, format: :json do
      include_context 'authorization token'

      example_request 'create:success' do
        expect(response_status).to eq(201)
      end

      example 'create:failure' do
        do_request params.tap { |p| p['event_series']['name'] = nil }
        expect(response_status).to eq(422)
      end
    end
  end

  context 'read operations' do
    before { subject.save }

    get api_event_series_index_path, format: :json do
      include_context 'authorization token'

      example_request 'index:success' do
        expect(response_status).to eq(200)
      end
    end

    get '/api/event_series/:id', format: :json do
      parameter :id, 'Unique Identifier', required: true
      let(:id) { subject.id }

      context 'authorized' do
        include_context 'authorization token'

        example_request 'show:success' do
          expect(response_status).to eq(200)
        end

        example 'show:failure' do
          do_request id: Faker::Number.number
          expect(response_status).to eq(404)
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

  context 'stars' do
    before { subject.save }

    parameter :event_series_id, 'Unique Identifier', required: true
    let(:event_series_id) { subject.id }

    context 'unauthenticated' do
      post '/api/event_series/:event_series_id/stars', format: :json do
        example_request 'authenticated stars' do
          expect(response_status).to eq(401)
        end
      end
      delete '/api/event_series/:event_series_id/stars', format: :json do
        example_request 'authenticated stars' do
          expect(response_status).to eq(401)
        end
      end
    end

    context 'authenticated' do
      include_context 'authorization token'
      post '/api/event_series/:event_series_id/stars', format: :json do
        example_request 'authenticated stars' do
          expect(response_status).to eq(201)
        end
      end
      delete '/api/event_series/:event_series_id/stars', format: :json do
        example_request 'authenticated stars' do
          expect(response_status).to eq(404)
        end
      end
    end
  end
end
