# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameEvents::Create, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(game: { type: Game }) }
    it { is_expected.to include(price: { type: Price, allow_nil: true, default: nil }) }
    it { is_expected.to include(event_type: { type: String, in: GameEventTypes.list }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(game_event: { type: GameEvent }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(game: game, price: price, event_type: event_type) }

    let(:event_type) { GameEventTypes.list.sample }
    let(:game) { create(:game) }
    let(:price) { create(:price) }
    let(:data) do
      GameEventDataBuilder.build(event_type: event_type, game: game, price: price).stringify_keys
    end

    it { is_expected.to be_success }

    it 'creates a new event for given game' do
      expect { result }.to change(game.events, :count).by(1)
    end

    it 'creates game event with builded data and given event type' do
      expect(result.game_event.attributes).to include('event_type' => event_type, 'data' => data)
    end

    it 'creates telegram event dispatch' do
      expect(result.game_event.dispatches.telegram.pending.count).to eq 1
    end
  end
end
