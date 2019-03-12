require 'rails_helper'

RSpec.describe UserReview, type: :model do
  let(:subject) { build :user_review }

  context 'validations' do
    it { is_expected.to validate_presence_of(:user).with_message(:required) }
    it { is_expected.to validate_presence_of(:reviewer).with_message(:required) }
    it { is_expected.not_to validate_presence_of(:reviewable) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:rating) }
    it do
      expect(subject).to validate_numericality_of(:rating).only_integer
        .is_greater_than_or_equal_to(1)
        .is_less_than_or_equal_to(10)
    end
  end

  context 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:user_reviews) }
    it { is_expected.to belong_to(:reviewer).inverse_of(:reviewed_users) }
    it { is_expected.to belong_to(:reviewable).inverse_of(:user_reviews).optional }
  end
end
