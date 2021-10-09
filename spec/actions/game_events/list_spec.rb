# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameEvents::List, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(game_events: { type: Enumerable }) }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    let!(:game_event_c) { create(:game_event, :price_added, created_at: Time.zone.yesterday, title: 'Astral') }
    let!(:game_event_b) { create(:game_event, :game_added, created_at: Time.zone.yesterday) }
    let!(:game_event_d) { create(:game_event, :price_added, created_at: Time.zone.yesterday, title: 'Zelda') }
    let!(:game_event_a) { create(:game_event, created_at: Time.zone.tomorrow) }

    it 'returns game events ordered by created_at, event_type and title' do
      expect(result.game_events.to_a).to eq [game_event_a, game_event_b, game_event_c, game_event_d]
    end
  end
end
