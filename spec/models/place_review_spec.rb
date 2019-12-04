require 'rails_helper'

RSpec.describe PlaceReview, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:place).inverse_of(:place_reviews) }
    it { is_expected.to belong_to(:user).inverse_of(:place_reviews) }
  end
end
