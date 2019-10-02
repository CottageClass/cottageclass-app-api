require 'rails_helper'

RSpec.describe User, type: :model do
  let(:subject) { build :user }

  context 'associations' do
    it { is_expected.to have_many(:event_series).inverse_of(:user) }
    it { is_expected.to have_many(:childcare_requests).inverse_of(:user) }
    it { is_expected.to have_many(:events).through(:event_series) }
    it { is_expected.to have_many(:devices) }
    it { is_expected.to have_many(:created_places) }
    it { is_expected.to have_many(:participants).inverse_of(:user).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).inverse_of(:recipient).dependent(:destroy) }
  end

  context 'save' do
    it { expect { subject.save }.to change(subject, :jti).from(nil) }

    it { expect { subject.save }.to change(Notification.user_creation, :count).from(0).to(1) }
  end

  context 'create' do
    context 'search_list_items' do
      it {
        subject.save
        expect(SearchListItem.where(user: subject)).to exist
      }
    end
  end

  context 'update' do
    before { subject.save }

    it 'sends sms' do
      expect { subject.update_attribute(:phone_number, '6092164398') }
        .to change(Notification.user_sms_welcome.reload, :count).from(0).to(1)
    end
  end

  context 'scope' do
    let(:child1) { build :child, birthday: '2 Jan, 2014' }
    let(:child2) { build :child, birthday: '2 Jan, 2014' }
    let(:subject) { create :user, children: [child1, child2] }

    it 'child_age_range' do
      # mock time as May 5, 2019
      allow(Time).to receive(:current).and_return(Time.strptime('1557082500', '%s'))
      expect(User.child_age_range(0, 10).where(id: subject.id).count).to eq 2
    end
  end

  context 'destroy' do
    let(:subject) { build :user, :with_children, :with_place }
    let(:other) { build :user, :with_children, latitude: subject.latitude, longitude: subject.longitude }

    it 'can be destroyed with some associations' do
      subject.save
      other.save
      subject.find_matches

      expect { subject.destroy }.to change(User, :count).from(2).to(1)
    end
  end

  context 'notification' do
    let(:subject) { build :user, :with_children, :with_place, :with_matched_user }

    it 'sends a user suggestion notification' do
      expect { subject.notify_user_suggestion }.to change(subject.notifications.user_suggestion, :count)
        .from(0)
        .to(1)
    end
    it 'does not send the same user suggestion notification twice' do
      subject.notify_user_suggestion
      expect { subject.notify_user_suggestion }.not_to change(subject.notifications.user_suggestion, :count)
    end
  end
end
