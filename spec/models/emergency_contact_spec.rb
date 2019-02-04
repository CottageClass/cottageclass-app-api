require 'rails_helper'

RSpec.describe EmergencyContact, type: :model do
  let(:user) { build :user, :with_children }
  let(:subject) { build :emergency_contact, contactable: user.children.sample }

  context 'validations' do
    it { is_expected.to validate_presence_of(:contactable).with_message(:required) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:phone_number) }
    it { is_expected.to validate_presence_of(:relationship) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:contactable).inverse_of(:emergency_contacts) }
  end
end
