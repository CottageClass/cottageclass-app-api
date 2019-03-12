require 'rails_helper'

RSpec.describe ParticipantChild, type: :model do
  let(:user) { build :user, :with_children }
  let(:event) { build :event }
  let(:participant) { build :participant, :with_participant_children, participable: event, user: user }
  let(:subject) { participant.participant_children.sample }

  context 'validations' do
    it { is_expected.to validate_presence_of(:participant).with_message(:required) }
    it { is_expected.to validate_presence_of(:child).with_message(:required) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:participant).inverse_of(:participant_children) }
    it { is_expected.to belong_to(:child).inverse_of(:participant_children) }
  end
end
