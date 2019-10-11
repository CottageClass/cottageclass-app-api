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
    it { is_expected.to have_one(:place).inverse_of(:events) }
    it { is_expected.to have_many(:participants).dependent(:destroy) }
    it { is_expected.to have_many(:participant_children) }
    it { is_expected.to have_many(:notifications).dependent(:nullify) }
    it { is_expected.to have_many(:participating_users).through(:participants) }
  end

  context 'create' do
    context 'search_list_items' do
      it {
        subject.save
        expect(SearchListItem.where(itemable: subject, user: subject.user)).to exist
      }
    end
  end

  context 'destroy' do
    let(:participants_count) { 2 }

    before do
      subject.save
      participants_count.times do
        user_with_children = create :user, :with_children, :with_phone_number
        create :participant, :with_participant_children, participable: subject, user: user_with_children
      end
    end

    it { expect { subject.destroy }.to change(Notification.event_destruction, :count).from(0).to(participants_count) }
  end

  context 'notify' do
    before { subject.save }

    let :participants do
      participants = create_list :participant, 2, :with_participant_children, participable: subject
      participants.each do |participant|
        participant.participant_children.each do |participant_child|
          participant_child.child.emergency_contacts = build_list :emergency_contact, 2, contactable: nil
        end
      end
      participants
    end

    context 'host: without participants' do
      it 'event_reminder_previous_week_host' do
        Timecop.freeze(1.week.before(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_previous_week_host.count).to eq(0)
        end
      end

      it 'event_reminder_previous_day_host' do
        Timecop.freeze(24.hours.before(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_previous_day_host.count).to eq(0)
        end
      end
    end

    context 'host: with participants' do
      before { participants }

      it 'event_reminder_previous_week_host' do
        Timecop.freeze(1.week.before(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_previous_week_host.count).to eq(1)
        end
      end

      it 'event_reminder_previous_day_host' do
        Timecop.freeze(24.hours.before(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_previous_day_host.reload.count).to eq(1)
        end
      end
    end

    context 'participants' do
      before { participants }

      it 'event_reminder_previous_day_participant' do
        Timecop.freeze(24.hours.before(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_previous_day_participant.count).to eq(participants.size)
          expect(subject.notifications.count).to eq(participants.size * 2 + 1 + 1)
        end
      end

      it 'event_reminder_same_day_participant' do
        Timecop.freeze(2.hours.ago(subject.starts_at)) do
          subject.notify

          expect(subject.notifications.event_reminder_same_day_participant.count).to eq(participants.size)
          expect(subject.notifications.count).to eq(participants.size * 2 + 1 + 1)
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
