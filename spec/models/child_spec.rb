require 'rails_helper'

RSpec.describe Child, type: :model do
  let(:subject) { build :child }

  context 'ages' do
    it 'has correct ages for under 1' do
      # mock time as May 5, 2019
      allow(Time).to receive(:current).and_return(Time.strptime('1557082500', '%s'))
      subject.birthday = '20 Jul, 2018'
      expect(subject.age).to eq(0)
      expect(subject.age_in_months).to eq(9)
    end
    it 'has correct ages for over 1' do
      # mock time as May 5, 2019
      allow(Time).to receive(:current).and_return(Time.strptime('1557082500', '%s'))
      subject.birthday = '2 Jan, 2014'
      expect(subject.age).to eq(5)
      expect(subject.age_in_months).to eq(64)
    end
  end

  context 'associations' do
    it { is_expected.to have_many(:emergency_contacts).dependent(:destroy) }
  end
end
