require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:subject) { build :notification }

  context 'validations' do
    it { is_expected.not_to validate_presence_of(:notifiable) }
    it { is_expected.to validate_presence_of(:recipient).with_message(:required) }
    it { is_expected.to validate_presence_of(:body) }
    it 'does not allow restricted recipients' do
      subject.valid?
      expect(subject.errors).to be_blank
      ClimateControl.modify RESTRICT_NOTIFICATIONS_TO: ([*31..40] - [subject.recipient.try(:id)]).sample(2).join(',') do
        subject.valid?
        expect(subject.errors).to include(:recipient)
      end
    end
  end

  context 'associations' do
    it { is_expected.to belong_to(:notifiable).inverse_of(:notifications) }
    it { is_expected.to belong_to(:recipient).inverse_of(:notifications) }
  end

  context 'create' do
    it('populates remote_identifier') { expect { subject.save }.to change(subject, :remote_identifier).from(nil) }
  end
end
