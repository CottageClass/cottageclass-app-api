require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:subject) { build :notification }

  context 'validations' do
    it { is_expected.not_to validate_presence_of(:notifiable) }
    it { is_expected.to validate_presence_of(:recipient).with_message(:required) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:notifiable).inverse_of(:notifications) }
    it { is_expected.to belong_to(:recipient).inverse_of(:notifications) }
  end

  context 'create' do
    it('sms_provider_identifier') {
      expect { subject.save }.to change(subject, :sms_provider_identifier).from(nil)
    }
  end
end
