require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:sender).inverse_of(:comments) }
    it { is_expected.to belong_to(:group).inverse_of(:comments) }
  end
end
