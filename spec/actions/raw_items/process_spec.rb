# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RawItems::Process, type: :action do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    let(:raw_item) { create(:raw_item, imported: false) }
    let(:adapted_data) { attributes_for(:game) }

    before do
      create(:raw_item, imported: true)
      allow(NintendoAlgoliaDataAdapter).to receive(:adapt).with(raw_item.data).and_return(adapted_data)
    end

    context 'when raw item is linked with game' do
      let(:raw_item) { create(:raw_item, :with_game, imported: false) }

      it 'doesn`t create games' do
        expect { result }.not_to change(Game, :count)
      end

      it 'doesn`t create game_added game event' do
        expect(GameEvents::Create).not_to receive(:call)

        result
      end
    end

    context 'when raw item isn`t linked with game' do
      let(:raw_item) { create(:raw_item, game: nil, imported: false) }

      it 'creates a new game' do
        expect { result }.to change(Game, :count).by(1)
      end

      it 'creates game_added game event' do
        expect(GameEvents::Create).to receive(:call)
          .with(event_type: GameEventTypes::GAME_ADDED, game: an_instance_of(Game))

        result
      end
    end

    it 'saves game with adapted data' do
      result

      expect(raw_item.reload.game.attributes).to include(adapted_data.deep_stringify_keys)
    end

    context 'when some error happens on development environment' do
      let(:error) { StandardError.new('some error') }

      before do
        allow(Rails.env).to receive(:development?).and_return(true)
        allow(NintendoAlgoliaDataAdapter).to receive(:adapt).and_raise(error)
      end

      it 'raises error' do
        expect { result }.to raise_error(error)
      end
    end

    context 'when some error happens on not development environment' do
      let(:error) { StandardError.new('some error') }

      before do
        allow(Rails.env).to receive(:development?).and_return(false)
        allow(NintendoAlgoliaDataAdapter).to receive(:adapt).and_raise(error)
      end

      it 'handles error with Sentry' do
        expect(Sentry).to receive(:capture_exception).with(error, extra: { raw_item: raw_item.data })

        result
      end
    end
  end
end
