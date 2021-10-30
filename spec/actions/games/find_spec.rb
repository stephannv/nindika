# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::Find, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(slug: { type: String }) }
    it { is_expected.to include(user: { type: User, allow_nil: true, default: nil }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(game: { type: Game }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(slug: slug) }

    context 'when game with given slug exists' do
      let(:game) { create(:game) }
      let(:slug) { game.slug }

      it 'returns found game' do
        expect(result.game).to eq game
      end
    end

    context 'when game with given slug doesn`t exist' do
      let(:slug) { 'not-found-slug' }

      it 'raises not found error' do
        expect { result }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
