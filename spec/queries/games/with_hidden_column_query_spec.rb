# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::WithHiddenColumnQuery, type: :query do
  describe '#call' do
    let(:user) { create(:user) }
    let!(:hidden_game) { create(:hidden_game, user: user).game }
    let!(:other_games) { create_list(:game, 5) }
    let!(:hidden_game_by_other_user) { create(:hidden_game).game }

    context 'when include hidden is true' do
      subject(:result) { described_class.call(user_id: user.id, include_hidden: true) }

      it 'returns all games including hidden games' do
        expect(result.to_a).to match_array [hidden_game, other_games, hidden_game_by_other_user].flatten
      end
    end

    context 'when only hidden is true' do
      subject(:result) { described_class.call(user_id: user.id, only_hidden: true) }

      it 'returns only hidden games' do
        expect(result.to_a).to match_array [hidden_game]
      end
    end

    context 'when only hidden and include hidden are false' do
      subject(:result) { described_class.call(user_id: user.id, include_hidden: false, only_hidden: false) }

      it 'returns all games excluding hidden games' do
        expect(result.to_a).to match_array [other_games, hidden_game_by_other_user].flatten
      end
    end

    context 'when game is hidden' do
      subject(:result) { described_class.call(user_id: user.id, include_hidden: true) }

      it 'sets hidden column as true' do
        expect(result.find_by(id: hidden_game.id).hidden).to be true
      end
    end

    context 'when game isn`t hidden' do
      subject(:result) { described_class.call(user_id: user.id, include_hidden: true) }

      it 'sets hidden column as false' do
        expect(result.find_by(id: hidden_game_by_other_user.id).hidden).to be false
      end
    end
  end
end
