require 'rails_helper'

RSpec.describe User, type: :model do
  let(:subject) { build :user }

  context 'associations' do
    it { is_expected.to have_many(:event_series).inverse_of(:user) }
    it { is_expected.to have_many(:childcare_requests).inverse_of(:user) }
    it { is_expected.to have_many(:events).through(:event_series) }
    it { is_expected.to have_many(:devices) }
    it { is_expected.to have_many(:places) }
    it { is_expected.to have_many(:participants).inverse_of(:user).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).inverse_of(:recipient).dependent(:destroy) }
  end

  context 'save' do
    it { expect { subject.save }.to change(subject, :jti).from(nil) }

    it 'obfuscates location' do
      expect(subject.fuzzy_latitude).to be_blank
      expect(subject.fuzzy_longitude).to be_blank

      subject.save

      expect(subject.fuzzy_latitude).not_to be_blank
      expect(subject.fuzzy_longitude).not_to be_blank
    end

    it 'generates time zone' do
      subject.time_zone = nil
      expect { subject.save }.to change(subject, :time_zone).from(nil)
    end

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

    let(:new_latitude) { 37.773972 }
    let(:new_longitude) { -122.431297 }

    it 'sends sms' do
      expect { subject.update_attribute(:phone_number, '6092164398') }
        .to change(Notification.user_sms_welcome.reload, :count).from(0).to(1)
    end

    it 'updates dependent events' do
      create :event_series, user: subject

      subject.events.reload.each do |event|
        expect(event.latitude).to eq(subject.latitude)
        expect(event.latitude).not_to eq(new_latitude)
        expect(event.longitude).to eq(subject.longitude)
        expect(event.longitude).not_to eq(new_longitude)
      end

      subject.update latitude: new_latitude, longitude: new_longitude

      subject.events.reload.each do |event|
        expect(event.latitude).to eq(new_latitude)
        expect(event.longitude).to eq(new_longitude)
      end
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
    let(:subject) { build :user, :with_children }
    let(:other) { build :user, :with_children, latitude: subject.latitude, longitude: subject.longitude }

    it 'can be destroyed with some associations' do
      subject.save
      other.save
      subject.find_matches

      expect { subject.destroy }.to change(User, :count).from(2).to(1)
    end
  end
end
