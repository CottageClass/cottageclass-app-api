require 'rails_helper'

RSpec.describe Star, type: :model do
  let(:subject) {build :star}

  context 'associations' do
    it { is_expected.to belong_to(:giver).inverse_of(:starred_items) }
  end

end
