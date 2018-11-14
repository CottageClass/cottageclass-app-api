require 'rails_helper'
require_relative '../../spec/support/shared_contexts/rake.rb'

RSpec.describe 'import:people_json' do
  include_context 'rake'

  let(:path_to_json) { 'spec/fixtures/people.json' }

  it 'imports users, including email, facebook_id, phone, location, network, availability, activities, and children' do
    expect {
      subject.invoke(path_to_json)
    }.to change {
      User.count
    }.from(0).to(131)

    marixsa = User.find_by(email: 'marixsa@gmail.com')

    expect(marixsa.name).to eq "Marixsa R"
    expect(marixsa.phone).to eq "(212) 920-4828"
    expect(marixsa.facebook_id).to eq "538259947"
    expect(marixsa.latitude).to eq "40.642485"
    expect(marixsa.longitude).to eq "-73.944122"
    expect(marixsa.network_code).to eq "flatbushfamilies"
    expect(marixsa.activities).to match_array ["spanish", "art", "music", "sports"]
    expect(marixsa.available_mornings).to eq true
    expect(marixsa.available_afternoons).to eq true
    expect(marixsa.available_weekends).to eq true
    expect(marixsa.available_evenings).to eq false
    expect(marixsa.children.count).to eq 3
    expect(marixsa.children.pluck(:first_name)).to match_array ["Tenoch", "Taina", "Tristan"]
  end

  it 'outputs a list of new network codes and created users'

  context 'when a user with the email already exists' do
    before(:each) do
      # don't use FactoryBot because want to maintain blank attributes
      User.create!(email: 'marixsa@gmail.com', first_name: 'MarixsaTest', password: 'demo')
    end

    it 'does not import the user' do
      expect {
        subject.invoke(path_to_json)
      }.to change {
        User.count
      }.from(1).to(131)

      marixsa = User.where(email: 'marixsa@gmail.com')
      marixsa = marixsa.first

      expect(marixsa.first_name).to eq "MarixsaTest"
      expect(marixsa.phone).to eq nil
      expect(marixsa.children.count).to eq 0
    end
  end
end
