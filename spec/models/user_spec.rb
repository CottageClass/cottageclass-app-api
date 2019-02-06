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

  context 'update' do
    before { subject.save }

    let(:new_latitude) { 37.773972 }
    let(:new_longitude) { -122.431297 }

    it 'updates dependent events' do
      create :event_series, :with_event_hosts, user: subject

      subject.events.reload.each do |event|
        expect(event.latitude).to eq(subject.latitude)
        expect(event.latitude).not_to eq(new_latitude)
        expect(event.longitude).to eq(subject.longitude)
        expect(event.longitude).not_to eq(new_longitude)
      end

      subject.update latitude: new_latitude, longitude: new_longitude

      subject.events.reload.each do |event|
        expect(event.latitude).to eq(new_latitude)
        expect(event.longitude).to eq(new_longitude)
      end
    end
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
