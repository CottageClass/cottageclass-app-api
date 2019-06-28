# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchListItem, type: :model do
  context 'no user provided' do
    let(:subject) { SearchListItem.new }

    it { expect(subject).to be_invalid }
  end

  context 'bad itemable provided' do
    let(:subject) { SearchListItem.new(user: (build :user), itemable: (build :user)) }

    it { expect { subject }.to raise_error(ActiveRecord::InverseOfAssociationNotFoundError) }
  end

  context 'accepts event' do
    let(:subject) { build :search_list_item, :with_event }

    it { expect(subject).to be_valid }
  end
end
