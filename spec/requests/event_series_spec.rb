require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'EventSeries' do
  include_context 'json headers'

  let(:user) { create :user }
  let(:subject) { build :event_series, :with_event_hosts, user: user }

  context 'write operations' do
    with_options scope: :event_series, with_example: true do
      parameter :name, 'Name', required: true
      parameter :start_date, 'Start Date', required: true
      parameter :starts_at, 'Start Time', required: true
      parameter :ends_at, 'End Time', required: true
      parameter :maximum_children, 'Maximum number of children allowed. Default: 0 (no limit)'
      parameter :child_age_minimum, 'Minimum age of child. Default: 0 (no limit)'
      parameter :child_age_maximum, 'Maximum age of child. Default: 0 (no limit)'
      parameter :repeat_for, 'Number of events this series. Default: 6'
      parameter :interval, 'Interval in weeks between events. Default: 4'
      parameter :has_pet, 'Has Pet?'
      parameter :activity_names, 'Activity Names'
      parameter :foods, 'Food Names'
      parameter :house_rules, 'House Rules'
      parameter :pet_description, 'Pet Description'
      parameter :event_hosts_attributes, 'Array of adults present at host venue'
    end

    %i[
      name
      start_date
      maximum_children
      child_age_minimum
      child_age_maximum
      repeat_for
      interval
      has_pet
      activity_names
      foods
      house_rules
      pet_description
    ].each do |attribute|
      let(attribute) { subject.send attribute }
    end
    %i[starts_at ends_at].each { |attribute| let(attribute) { subject.send(attribute).to_s :time } }
    let :event_hosts_attributes do
      subject.event_hosts.map { |event_host| event_host.attributes.with_indifferent_access.slice :name, :email, :phone }
    end

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

    put '/api/event_series/:id', format: :json do
      include_context 'authorization token'
      before { subject.save }

      with_options scope: :event_series, with_example: true do
        parameter :paused_from, 'Pause Start Date'
        parameter :paused_until, 'Pause End Date'
      end

      let(:id) { subject.id }
      let(:paused_from) { subject.paused_from }
      let(:paused_until) { subject.paused_until }

      example 'update:success' do
        explanation 'To pause automatic event creation forever, set :paused_until to nil'
        do_request
        expect(response_status).to eq(200)
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
end
