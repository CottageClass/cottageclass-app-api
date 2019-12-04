require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  let(:subject) { build :user_group }

  context 'associations' do
    it { is_expected.to have_many(:user_group_memberships).inverse_of(:user_group) }
    it { is_expected.to have_many(:members).through(:user_group_memberships) }
    it { is_expected.to have_many(:comments).inverse_of(:group) }
  end

  context 'notifications' do
    let(:sender) { create :user }
    let(:user) { create :user }

    it {
      subject.save
      subject.members << user
      subject.members << sender

      subject.save
      expect { subject.comments.create sender: sender }.to change(user.notifications.new_group_message, :count).from(0).to(1)
      expect { subject.comments.create sender: sender }.not_to change(sender.notifications.new_group_message, :count)
    }
  end
end
