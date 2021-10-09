# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HiddenGames::Destroy, type: :actor do
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

    let(:hidden_game) { create(:hidden_game) }
    let(:user) { hidden_game.user }
    let(:game) { hidden_game.game }

    it { is_expected.to be_success }

    it 'removes game from user hidden list' do
      result

      expect(user.hidden_list.exists?(id: game.id)).to eq false
    end

    context 'when game cannot be removed from hidden list' do
      let(:game) { Game.new(id: Faker::Internet.uuid) }

      it { is_expected.to be_failure }
    end
  end
end
