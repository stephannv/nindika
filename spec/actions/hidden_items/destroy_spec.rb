# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HiddenItems::Destroy, type: :actor do
  describe 'Inputs' do
    subject { described_class.inputs }

    it { is_expected.to include(user: { type: User }) }
    it { is_expected.to include(item_id: { type: String }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result(user: user, item_id: item.id) }

    let(:hidden_item) { create(:hidden_item) }
    let(:user) { hidden_item.user }
    let(:item) { hidden_item.item }

    it { is_expected.to be_success }

    it 'removes item from user hidden list' do
      result

      expect(user.hidden_list.exists?(id: item.id)).to be false
    end

    context 'when item cannot be removed from hidden list' do
      let(:item) { Item.new(id: Faker::Internet.uuid) }

      it { is_expected.to be_failure }
    end
  end
end
