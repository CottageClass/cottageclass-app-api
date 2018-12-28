require 'rails_helper'

RSpec.describe Participant, type: :model do
  let(:subject) { build :participant }

  context 'validations' do
    it { is_expected.to validate_presence_of(:participable).with_message(:required) }
    it { is_expected.to validate_presence_of(:user).with_message(:required) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:participable).inverse_of(:participants) }
    it { is_expected.to belong_to(:user).inverse_of(:participants) }
    it { is_expected.to have_many(:participant_children).inverse_of(:participant).dependent(:destroy) }
  end
end
