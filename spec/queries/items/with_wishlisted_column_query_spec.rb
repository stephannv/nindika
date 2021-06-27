# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::WithWishlistedColumnQuery, type: :query do
  subject(:result) { described_class.call(user_id: user.id) }

  describe '#call' do
    let(:user) { create(:user) }
    let!(:wishlisted_item) { create(:wishlist_item, user: user).item }

    before do
      create_list(:item, 5)
      create(:wishlist_item) # wishlisted by other user
    end

    it 'doesn`t filter items' do
      expect(result.size).to eq 7
    end

    context 'when item has been wishlisted by user' do
      it 'sets wishlisted to true' do
        expect(result.find(wishlisted_item.id)).to be_wishlisted
      end
    end

    context 'when item hasn`t been wishlisted by user' do
      it 'sets wishlisted to false' do
        result.where.not(id: wishlisted_item.id).each do |item|
          expect(item).not_to be_wishlisted
        end
      end
    end
  end
end
