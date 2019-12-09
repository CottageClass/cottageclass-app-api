require 'rails_helper'

RSpec.describe Star, type: :model do
  context 'associations' do
    let(:subject) { build :star }

    it { is_expected.to belong_to(:giver).inverse_of(:stars) }
    it { is_expected.to belong_to(:starable).inverse_of(:received_stars) }
  end

  context 'starables' do
    let(:starable) { build :event_series }
    let(:subject) { build :star, starable: starable }

    it {
      starable.save
      expect { subject.save! }.to change(starable.received_stars, :count).from(0).to(1)
    }
  end
end
