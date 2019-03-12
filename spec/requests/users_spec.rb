require 'rails_helper'

RSpec.describe 'requesting users', type: :request do
  describe 'inquiries' do
    let!(:provider)               { FactoryBot.create(:user) }
    let!(:non_messaged_provider)  { FactoryBot.create(:user) }
    let!(:seeker_1)               { FactoryBot.create(:user) }
    let!(:seeker_2)               { FactoryBot.create(:user) }
    let!(:seeker_3)               { FactoryBot.create(:user) }

    let :headers do
      {
        'ACCEPT': 'application/json',
        'HTTP_ACCEPT': 'application/json'
      }
    end

    before do
      FactoryBot.create(:message, sender: seeker_1, receiver: provider)
      FactoryBot.create(:message, sender: seeker_1, receiver: provider)
      FactoryBot.create(:message, sender: seeker_2, receiver: provider)
    end

    it 'requires authorization' do
      get inquiries_path(provider), headers: headers

      expect(response.status).to eq 401
    end

    it 'returns only users who have requested care (messaged) the provider before' do
      get inquiries_path(provider), headers: authenticated_header(provider)

      inquiry_phones = JSON.parse(response.body).fetch('data', []).map { |u| u.dig('attributes', 'phone') }.compact
      expect(response.status).to eq 200
      expect(inquiry_phones).to include seeker_1.phone
      expect(inquiry_phones).to include seeker_2.phone
      expect(inquiry_phones).not_to include seeker_3.phone
      expect(inquiry_phones).not_to include non_messaged_provider.phone
    end

    it 'does not include a user more than once' do
      get inquiries_path(provider), headers: authenticated_header(provider)

      inquirer_ids = JSON.parse(response.body)['data'].map { |u| u['id'].to_i }
      expect(response.status).to eq 200
      expect(inquirer_ids.length).to eq 2
      expect(inquirer_ids).to include seeker_1.id
      expect(inquirer_ids).to include seeker_2.id
      expect(inquirer_ids).not_to include seeker_3.id
      expect(inquirer_ids).not_to include non_messaged_provider.id
    end
  end
end
