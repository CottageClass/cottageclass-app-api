require 'rails_helper'

RSpec.describe PlaceReview, type: :model do
  context 'attributes' do
    it {
      expect(subject).to validate_numericality_of(:stars)
        .is_greater_than_or_equal_to(1)
        .is_less_than_or_equal_to(5)
        .only_integer
      expect(subject).to validate_presence_of(:content)
    }
  end

  context 'associations' do
    it { is_expected.to belong_to(:place).inverse_of(:place_reviews) }
    it { is_expected.to belong_to(:user).inverse_of(:place_reviews) }
  end
end
