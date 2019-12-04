require 'rails_helper'

RSpec.describe UserGroupMembership, type: :model do
  let(:subject) { build :user_group_membership }

  context 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:user_group_memberships) }
    it { is_expected.to belong_to(:user_group).inverse_of(:user_group_memberships) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_uniqueness_of(:user_group_id).scoped_to(:user_id) }
  end
end
