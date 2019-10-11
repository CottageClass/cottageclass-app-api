require 'rails_helper'

RSpec.describe Place, type: :model do
  let(:user) { build :user }
  let(:subject) { build :place, creator: user }

  context 'validations' do
    it { is_expected.to validate_presence_of(:google_id) }
    it { is_expected.to validate_uniqueness_of(:apartment_number).scoped_to(:google_id) }
  end

  context 'associations' do
    it { is_expected.to have_many(:event_series).inverse_of(:place) }
  end

  context 'detachable' do
    it 'persists when its user is destroyed' do
      expect { user.destroy }.not_to change(subject, :nil?)
    end
  end
end
