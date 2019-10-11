require 'rails_helper'
require 'byebug'

RSpec.describe EventSeries, type: :model do
  let(:subject) { build :event_series }

  context 'validations' do
    it { expect(subject).to validate_presence_of(:user).with_message(:required) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:ends_at) }
    it { is_expected.to validate_numericality_of(:maximum_children).is_greater_than_or_equal_to(0).only_integer }
    it { is_expected.to validate_numericality_of(:child_age_minimum).is_greater_than_or_equal_to(0).only_integer }
    it { is_expected.to validate_numericality_of(:child_age_maximum).is_greater_than_or_equal_to(0).only_integer }
    it { is_expected.to validate_numericality_of(:repeat_for).is_greater_than(0).only_integer }
    it { is_expected.to validate_numericality_of(:interval).is_greater_than(0).only_integer }
  end

  context 'associations' do
    it { is_expected.to belong_to(:place).inverse_of(:event_series).optional }
    it { expect(subject).to belong_to(:user).inverse_of(:event_series) }
    it { is_expected.to have_many(:events).inverse_of(:event_series).dependent(:destroy) }
  end

  context 'autosave_records' do
    it {
      expect { subject.save }.to change(subject.place, :new_record?).from(true).to(false)
      # verify that autosave only applies to new records
      subject.place.apartment_number = '4c'
      expect { subject.save }.not_to change(subject.place, :apartment_number)
    }
  end

  context 'create' do
    it { expect { subject.save }.to change(subject.events, :count).from(0).to(subject.repeat_for) }
  end
end
