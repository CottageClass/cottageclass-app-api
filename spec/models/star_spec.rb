require 'rails_helper'

RSpec.describe Star, type: :model do
  let(:subject) {build :star}

  context 'associations' do
    it { is_expected.to belong_to(:giver).inverse_of(:stars) }
    it { is_expected.to belong_to(:starable).inverse_of(:received_stars) }
  end

end
