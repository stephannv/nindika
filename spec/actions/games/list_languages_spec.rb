# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::ListLanguages, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(languages: { type: Array }) }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    before do
      create(:game, languages: %w[b])
      create(:game, languages: %w[c a d])
      create(:game, languages: %w[b d])
    end

    it 'returns languages ordered by name' do
      expect(result.languages).to eq %w[a b c d]
    end
  end
end
