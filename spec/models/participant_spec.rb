require 'rails_helper'

RSpec.describe Participant, type: :model do
  let(:user) { create :user, :with_children }
  let(:event) { create :event, maximum_children: 2 }
  let(:subject) { build :participant, :with_participant_children, participable: event, user: user }

  context 'validations' do
    it { is_expected.to validate_presence_of(:participable).with_message(:required) }
    it { is_expected.to validate_presence_of(:user).with_message(:required) }
    it {
      event.update maximum_children: 1
      subject.valid?
      expect(subject.errors).to include(:base)
    }
  end

  context 'associations' do
    it { is_expected.to belong_to(:participable).inverse_of(:participants) }
    it { is_expected.to belong_to(:user).inverse_of(:participants) }
    it { is_expected.to have_many(:participant_children).inverse_of(:participant).dependent(:destroy) }
  end

  context 'notify' do
    it { expect { subject.save }.to change(Notification.participant_creation, :count).from(0).to(1) }
    it {
      user.children.each { |child| child.emergency_contacts = build_list :emergency_contact, 2, contactable: nil }
      expect { subject.save }.to change(Notification.participant_creation_host, :count).from(0).to(1)
    }
  end
end
