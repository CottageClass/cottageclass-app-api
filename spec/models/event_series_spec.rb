require 'rails_helper'

RSpec.describe EventSeries, type: :model do
  let(:subject) { build :event_series, :with_event_hosts }

  context 'validations' do
    it { is_expected.to validate_presence_of(:user).with_message(:required) }
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
    it { is_expected.to belong_to(:user).inverse_of(:event_series) }
    it { is_expected.to have_many(:events).inverse_of(:event_series).dependent(:destroy) }
    it { is_expected.to have_and_belong_to_many(:event_hosts) }
  end

  context 'create' do
    it { expect { subject.save }.to change(subject.events, :count).from(0).to(subject.repeat_for) }
    it { expect { subject.save }.not_to change(Notification.event_creation_host, :count) }
    it 'generates time zone' do
      subject.time_zone = nil
      expect { subject.save }.to change(subject, :time_zone).from(nil)
    end
  end

  context 'event generator' do
    before { subject.save }

    it 'create_next_event' do
      last_event = subject.events.upcoming.last
      Timecop.freeze 2.hours.since(last_event.ends_at) do
        expect(subject.events.upcoming.count).to eq(0)
        subject.create_next_event
        expect(subject.events.upcoming.count).to eq(1)
        expect(subject.events.upcoming.last.starts_at).to eq(subject.interval.weeks.since(last_event.starts_at))
      end
    end

    it 'paused' do
      subject.assign_attributes paused_from: 1.day.since(Time.zone.today), paused_until: 1.month.since(Time.zone.today)

      expect(subject).not_to be_paused
      Timecop.freeze 2.hours.since(subject.paused_from) do
        expect(subject).to be_paused
      end
      Timecop.freeze 2.hours.since(subject.paused_until) do
        expect(subject).not_to be_paused
      end

      subject.assign_attributes paused_until: nil
      Timecop.freeze rand(10).weeks.since(subject.paused_from) do
        expect(subject).to be_paused
      end
    end
  end
end
