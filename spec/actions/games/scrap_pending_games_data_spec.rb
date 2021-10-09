# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::ScrapPendingGamesData, type: :actions do
  describe 'Inputs' do
    subject { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    let(:pending_scrap) { instance_double(ActiveRecord::Relation) }
    let(:game_a) { Game.new }
    let(:game_b) { Game.new }

    before do
      allow(Game).to receive(:pending_scrap).and_return(pending_scrap)
      allow(pending_scrap).to receive(:find_each).with(batch_size: 200).and_yield(game_a).and_yield(game_b)
    end

    it 'scraps data for each pending scrap game' do
      [game_a, game_b].each { |i| expect(Games::ScrapData).to receive(:call).with(game: i) }

      result
    end

    context 'when some error happens on development environment' do
      let(:error) { StandardError.new('some error') }

      before do
        allow(Rails.env).to receive(:development?).and_return(true)
        allow(Games::ScrapData).to receive(:call).and_raise(error)
      end

      it 'raises error' do
        expect { result }.to raise_error(error)
      end
    end

    context 'when some error happens on not development environment' do
      let(:error) { StandardError.new('some error') }

      before do
        allow(Rails.env).to receive(:development?).and_return(false)
        allow(Games::ScrapData).to receive(:call).and_raise(error)
      end

      it 'handles error with Sentry' do
        expect(Sentry).to receive(:capture_exception).with(error, extra: { game_id: game_a.id }).twice

        result
      end
    end
  end
end
