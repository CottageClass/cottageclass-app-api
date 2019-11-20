require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  let(:subject) { build :user_group }

  context 'associations' do
    it { is_expected.to have_many(:user_group_memberships).inverse_of(:user_group) }
    it { is_expected.to have_many(:members).through(:user_group_memberships).inverse_of(:user_groups) }
    it { is_expected.to have_many(:comments).inverse_of(:group) }
  end
end
