require 'rails_helper'
require 'rspec_api_documentation/dsl'

RSpec.resource 'Event' do
  include_context 'json headers'

  let(:user) { create :user, :with_children }

  context 'index' do
    before { create_list :event_series, 5, :with_event_hosts, user: user }

    get '/api/events/:skope', format: :json do
      let(:skope) { nil }

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

          example format('%s:success', name) do
            explanation ':page and :page_size are optional parameters.'\
            'If :page is omitted, the endpoint returns all records for the scope. Default value for :page_size is 10.'
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
  end

  context 'show' do
    include_context 'authorization token'

    get '/api/events/:id', format: :json do
      let(:event_series) { create :event_series, :with_event_hosts, user: user }
      let(:id) { event_series.events.sample.id }

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
  end
end
