require 'rails_helper'

RSpec.describe ChildcareRequest, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:childcare_requests) }
  end
end
