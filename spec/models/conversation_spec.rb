require 'rails_helper'

RSpec.describe Conversation, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:initiator).with_message(:required) }
    it { is_expected.to validate_presence_of(:recipient).with_message(:required) }
    it { is_expected.to validate_presence_of(:last_message) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:initiator) }
    it { is_expected.to belong_to(:recipient) }
    it { is_expected.to belong_to(:last_message) }
  end
end
