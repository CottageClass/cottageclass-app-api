require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:sender).inverse_of(:comments) }
    it { is_expected.to belong_to(:group).inverse_of(:comments) }
  end

  context 'scope' do
    describe 'recent' do
      let(:new_comment) { FactoryBot.create :comment, created_at: 47.hours.ago }
      let(:old_comment) { FactoryBot.create :comment, created_at: 49.hours.ago }

      it 'includes correct comments' do
        comments = described_class.recent
        expect(comments).to include new_comment
        expect(comments).not_to include old_comment
      end
    end
  end
end
