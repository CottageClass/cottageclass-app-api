require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:event_series).inverse_of(:user) }
    it { is_expected.to have_many(:events).through(:event_series) }

    describe 'inquiries' do
      it 'returns users who have messaged the user for childcare' do
        parent1 = FactoryBot.create(:user)
        parent2 = FactoryBot.create(:user)
        parent3 = FactoryBot.create(:user)
        parent4 = FactoryBot.create(:user)
        FactoryBot.create(:message, receiver: parent1, sender: parent2)
        FactoryBot.create(:message, receiver: parent1, sender: parent3)

        expect(parent1.inquirers).to include(parent2, parent3)
        expect(parent1.inquirers).not_to include(parent4)
      end
    end
  end
end
