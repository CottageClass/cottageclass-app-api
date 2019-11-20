require 'rails_helper'

RSpec.describe UserGroupMembership, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:user_group_memberships) }
    it { is_expected.to belong_to(:user_group).inverse_of(:user_group_memberships) }
  end
end
