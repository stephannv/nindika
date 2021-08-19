# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemEvents::List, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(item_events: { type: Enumerable }) }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    let!(:item_event_c) { create(:item_event, :price_added, created_at: Time.zone.yesterday, title: 'Astral') }
    let!(:item_event_b) { create(:item_event, :game_added, created_at: Time.zone.yesterday) }
    let!(:item_event_d) { create(:item_event, :price_added, created_at: Time.zone.yesterday, title: 'Zelda') }
    let!(:item_event_a) { create(:item_event, created_at: Time.zone.tomorrow) }

    it 'returns item events ordered by created_at, event_type and title' do
      expect(result.item_events.to_a).to eq [item_event_a, item_event_b, item_event_c, item_event_d]
    end
  end
end
