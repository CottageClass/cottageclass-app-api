# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchListItem, type: :model do
  context 'no user provided' do
    let(:subject) { SearchListItem.new }

    it { expect(subject).to be_invalid }
  end

  context 'duplicate users with no itemable' do
    let(:user) { create :user }
    let(:subject) { SearchListItem.new(user: user) }
    let(:second_subject) { SearchListItem.new(user: user) }

    it {
      expect do
        subject.save
        second_subject.save
      end.to raise_error(ActiveRecord::RecordNotUnique)
    }
  end

  context 'bad itemable provided' do
    let(:subject) { SearchListItem.new(user: (build :user), itemable: (build :user)) }

    it { expect { subject }.to raise_error(ActiveRecord::InverseOfAssociationNotFoundError) }
  end

  context 'duplicate itemable' do
    let(:event) { build :event }
    let(:user) { build :user }
    let(:subject) { SearchListItem.create(user: (build :user), itemable: event) }

    it do
      subject
      expect(SearchListItem.new(user: (build :user), itemable: event)).to be_invalid
    end
  end

  context 'delegation' do
    it { expect(subject).to respond_to(*User::PUBLIC_ATTRIBUTES) }
  end
end
