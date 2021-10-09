# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::ListGenres, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(genres: { type: Array }) }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    before do
      create(:game, genres: %w[b])
      create(:game, genres: %w[c a d])
      create(:game, genres: %w[b d])
    end

    it 'returns genres ordered by name' do
      expect(result.genres).to eq %w[a b c d]
    end
  end
end
