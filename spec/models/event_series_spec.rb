require 'rails_helper'

RSpec.describe EventSeries, type: :model do
  let(:subject) { build :event_series }

  context 'validations' do
    it { is_expected.to validate_presence_of(:user).with_message(:required) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:ends_at) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:event_series) }
    it { is_expected.to have_many(:events).inverse_of(:event_series).dependent(:destroy) }
    it { is_expected.to have_and_belong_to_many(:event_hosts) }
  end

  context 'create' do
    it { expect { subject.save }.to change(subject.events, :count).from(0).to(subject.repeat_for) }
  end
end
