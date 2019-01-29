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
    it { is_expected.to have_many(:notifications).dependent(:nullify) }
    it { is_expected.to have_many(:participating_users).through(:participants) }
    it { is_expected.to have_and_belong_to_many(:event_hosts) }
  end

  context 'create' do
    it 'generates time zone' do
      subject.time_zone = nil
      expect { subject.save }.to change(subject, :time_zone).from(nil)
    end
  end

  context 'destroy' do
    before do
      subject.save
      participants_count.times do
        user_with_children = create :user, :with_children
        create :participant, :with_participant_children, participable: subject, user: user_with_children
      end
    end

    let(:participants_count) { 2 }

    it { expect { subject.destroy }.to change(Notification.event_destruction, :count).by(participants_count) }
  end

  context 'notify' do
    before { subject.save }

    context 'host' do
      it 'event_reminder_previous_week_host' do
        Timecop.freeze(1.week.before(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_previous_week_host.count).to eq(1)
          expect(subject.notifications.count).to eq(1)
        end
      end

      it 'event_reminder_previous_day_host' do
        Timecop.freeze(24.hours.before(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_previous_day_host.count).to eq(1)
          expect(subject.notifications.count).to eq(1)
        end
      end

      it 'event_feedback_host/event_congratulation_host' do
        Timecop.freeze(subject.ends_at) do
          subject.notify

          expect(subject.notifications.event_feedback_host.count).to eq(1)
          expect(subject.notifications.event_congratulation_host.count).to eq(1)
          expect(subject.notifications.count).to eq(2)
        end
      end
    end

    context 'participants' do
      before { participants }

      let(:participants) { create_list :participant, 2, :with_participant_children, participable: subject }

      it 'event_reminder_previous_day_participant' do
        Timecop.freeze(24.hours.before(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_previous_day_participant.count).to eq(participants.size)
          expect(subject.notifications.count).to eq(participants.size * 2 + 1)
        end
      end

      it 'event_reminder_same_day_participant' do
        Timecop.freeze(2.hours.ago(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_same_day_participant.count).to eq(participants.size)
          expect(subject.notifications.count).to eq(participants.size * 2 + 1)
        end
      end

      it 'event_feedback_participant' do
        Timecop.freeze(30.minutes.since(subject.ends_at)) do
          subject.notify

          expect(subject.notifications.event_feedback_participant.count).to eq(participants.size)
          expect(subject.notifications.count).to eq(participants.size * 2 + 2)
        end
      end
    end
  end
end
