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
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_many(:participating_users).through(:participants) }
    it { is_expected.to have_and_belong_to_many(:event_hosts) }
  end

  context 'create' do
    it 'generates time zone' do
      subject.time_zone = nil
      expect { subject.save }.to change(subject, :time_zone).from(nil)
    end
  end

  context 'notify' do
    before do
      subject.save
      participants
    end

    let(:participants) { create_list :participant, 2, :with_participant_children, participable: subject }

    it 'event_reminder_previous_day_participant' do
      expect { subject.notify }.not_to change(subject.notifications, :count)

      Timecop.freeze(1.week.before(subject.starts_at)) do
        expect { subject.notify }.to change(subject.notifications, :count).by(1)
        expect { subject.notify }.not_to change(subject.notifications, :count)
      end

      Timecop.freeze(1.day.ago(subject.starts_at)) do
        expect { subject.notify }.to change(subject.notifications, :count).by(participants.size + 1)
        expect { subject.notify }.not_to change(subject.notifications, :count)
      end

      Timecop.freeze(2.hours.ago(subject.starts_at)) do
        expect { subject.notify }.to change(subject.notifications, :count).by(participants.size)
        expect { subject.notify }.not_to change(subject.notifications, :count)
      end

      Timecop.freeze(subject.ends_at) do
        expect { subject.notify }.to change(subject.notifications, :count).by(2)
        expect { subject.notify }.not_to change(subject.notifications, :count)
      end

      Timecop.freeze(30.minutes.since(subject.ends_at)) do
        expect { subject.notify }.to change(subject.notifications, :count).by(participants.size)
        expect { subject.notify }.not_to change(subject.notifications, :count)
      end
    end
  end
end
