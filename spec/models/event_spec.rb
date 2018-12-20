require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:subject) { build :event }

  context 'validations' do
    it { is_expected.to validate_presence_of(:event_series).with_message(:required) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:ends_at) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:event_series).inverse_of(:events) }
  end
end
