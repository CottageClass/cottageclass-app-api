require 'rails_helper'

RSpec.describe Device, type: :model do
  let(:subject) { build :device }

  context 'validations' do
    it { is_expected.to validate_presence_of(:user).with_message(:required) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:devices) }
  end
end
