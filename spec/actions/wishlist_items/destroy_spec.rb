# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WishlistItems::Destroy, type: :actor do
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

    let(:wishlist_item) { create(:wishlist_item) }
    let(:user) { wishlist_item.user }
    let(:item) { wishlist_item.item }

    it { is_expected.to be_success }

    it 'removes item from user wishlist' do
      result

      expect(user.wishlist.exists?(id: item.id)).to eq false
    end

    context 'when item cannot be removed from wishlist' do
      let(:item) { Item.new(id: Faker::Internet.uuid) }

      it { is_expected.to be_failure }
    end
  end
end
