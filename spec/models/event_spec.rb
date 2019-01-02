require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:subject) { build :event }

  context 'validations' do
    it { is_expected.to validate_presence_of(:event_series).with_message(:required) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:ends_at) }
    it { is_expected.to validate_numericality_of(:maximum_children).is_greater_than_or_equal_to(0).only_integer }
    it { is_expected.to validate_numericality_of(:child_age_minimum).is_greater_than_or_equal_to(0).only_integer }
    it { is_expected.to validate_numericality_of(:child_age_maximum).is_greater_than_or_equal_to(0).only_integer }
  end

  context 'associations' do
    it { is_expected.to belong_to(:event_series).inverse_of(:events) }
    it { is_expected.to have_many(:participants).dependent(:destroy) }
    it { is_expected.to have_many(:participant_children) }
    it { is_expected.to have_many(:participating_users).through(:participants) }
    it { is_expected.to have_and_belong_to_many(:event_hosts) }
  end

  context 'create' do
    it 'generates time zone' do
      subject.time_zone = nil
      expect { subject.save }.to change(subject, :time_zone).from(nil)
    end
  end
end
