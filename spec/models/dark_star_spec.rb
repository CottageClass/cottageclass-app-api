require 'rails_helper'

RSpec.describe DarkStar, type: :model do
  let(:subject) { build :dark_star }

  context 'associations' do
    it { is_expected.to belong_to(:giver).inverse_of(:dark_stars) }
    it { is_expected.to belong_to(:recipient).inverse_of(:received_dark_stars) }
  end
end
