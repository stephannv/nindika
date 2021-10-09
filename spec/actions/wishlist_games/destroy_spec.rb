# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WishlistGames::Destroy, type: :actor do
  describe 'Inputs' do
    subject { described_class.inputs }

    it { is_expected.to include(user: { type: User }) }
    it { is_expected.to include(game_id: { type: String }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result(user: user, game_id: game.id) }

    let(:wishlist_game) { create(:wishlist_game) }
    let(:user) { wishlist_game.user }
    let(:game) { wishlist_game.game }

    it { is_expected.to be_success }

    it 'removes game from user wishlist' do
      result

      expect(user.wishlist.exists?(id: game.id)).to eq false
    end

    context 'when game cannot be removed from wishlist' do
      let(:game) { Game.new(id: Faker::Internet.uuid) }

      it { is_expected.to be_failure }
    end
  end
end
