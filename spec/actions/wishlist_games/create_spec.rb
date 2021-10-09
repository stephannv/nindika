# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WishlistGames::Create, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(user: { type: User }) }
    it { is_expected.to include(game_id: { type: String }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(wishlist_game: { type: WishlistGame }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(user: user, game_id: game.id) }

    let(:user) { create(:user) }
    let(:game) { create(:game) }

    context 'when attributes are valid' do
      it { is_expected.to be_success }

      it 'adds game to user wishlist' do
        result

        expect(user.wishlist.exists?(id: game.id)).to eq true
      end
    end

    context 'when attributes are invalid' do
      let(:game) { Game.new(id: Faker::Internet.uuid) }

      it { is_expected.to be_failure }

      it 'doesn`t add game to user wishlist' do
        result

        expect(user.wishlist.exists?(id: game.id)).to eq false
      end
    end
  end
end
