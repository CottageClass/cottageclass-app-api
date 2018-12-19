require 'rails_helper'

RSpec.describe EventHost, type: :model do
  let(:subject) { build :event_host }

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'associations' do
    it { is_expected.to have_and_belong_to_many(:event_series) }
  end
end
