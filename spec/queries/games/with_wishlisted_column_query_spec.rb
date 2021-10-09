# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::WithWishlistedColumnQuery, type: :query do
  subject(:result) { described_class.call(user_id: user.id) }

  describe '#call' do
    let(:user) { create(:user) }
    let!(:wishlisted_game) { create(:wishlist_game, user: user).game }

    before do
      create_list(:game, 5)
      create(:wishlist_game) # wishlisted by other user
    end

    context 'when only_wishlisted is false' do
      it 'doesn`t filter games' do
        expect(result.size).to eq 7
      end
    end

    context 'when only_wishlisted is true' do
      subject(:result) { described_class.call(user_id: user.id, only_wishlisted: true) }

      it 'returns only games on user wishlist' do
        expect(result.to_a).to eq [wishlisted_game]
      end
    end

    context 'when game has been wishlisted by user' do
      it 'sets wishlisted to true' do
        expect(result.find(wishlisted_game.id)).to be_wishlisted
      end
    end

    context 'when game hasn`t been wishlisted by user' do
      it 'sets wishlisted to false' do
        result.where.not(id: wishlisted_game.id).each do |game|
          expect(game).not_to be_wishlisted
        end
      end
    end
  end
end
