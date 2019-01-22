require 'rails_helper'

RSpec.describe User, type: :model do
  let(:subject) { build :user }

  context 'associations' do
    it { is_expected.to have_many(:event_series).inverse_of(:user) }
    it { is_expected.to have_many(:events).through(:event_series) }
    it { is_expected.to have_many(:participants).inverse_of(:user).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).inverse_of(:recipient).dependent(:destroy) }
  end

  context 'save' do
    it 'obfuscates location' do
      expect(subject.fuzzy_latitude).to be_blank
      expect(subject.fuzzy_longitude).to be_blank

      subject.save

      expect(subject.fuzzy_latitude).not_to be_blank
      expect(subject.fuzzy_longitude).not_to be_blank
    end

    it 'generates time zone' do
      subject.time_zone = nil
      expect { subject.save }.to change(subject, :time_zone).from(nil)
    end

    it { expect { subject.save }.to change(Notification.user_creation, :count).from(0).to(1) }
  end

  context 'inquiries' do
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
