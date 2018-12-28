require 'rails_helper'

RSpec.describe Child, type: :model do
  let(:subject) { build :child }

  context 'associations' do
    it { is_expected.to have_many(:participant_children).inverse_of(:child).dependent(:destroy) }
  end
end
