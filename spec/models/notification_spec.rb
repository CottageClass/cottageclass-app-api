require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:subject) { build :notification }

  context 'validations' do
    it { is_expected.to validate_presence_of(:recipient).with_message(:required) }
    it { is_expected.to validate_presence_of(:body) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:recipient).inverse_of(:notifications) }
  end

  context 'create' do
    it('populates remote_identifier') { expect { subject.save }.to change(subject, :remote_identifier).from(nil) }
  end
end
