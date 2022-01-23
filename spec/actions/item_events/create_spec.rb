# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemEvents::Create, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(item: { type: Item }) }
    it { is_expected.to include(price: { type: Price, allow_nil: true, default: nil }) }
    it { is_expected.to include(event_type: { type: String, in: ItemEventTypes.list }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(item_event: { type: ItemEvent }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(item: item, price: price, event_type: event_type) }

    let(:event_type) { ItemEventTypes.list.sample }
    let(:item) { create(:item) }
    let(:price) { create(:price) }
    let(:data) do
      ItemEventDataBuilder.build(event_type: event_type, item: item, price: price).stringify_keys
    end

    it { is_expected.to be_success }

    it 'creates a new event for given item' do
      expect { result }.to change(item.events, :count).by(1)
    end

    it 'creates item event with builded data and given event type' do
      expect(result.item_event.attributes).to include('event_type' => event_type, 'data' => data)
    end

    context 'when item is featured' do
      let(:item) { create(:item, :featured) }

      it 'creates telegram event dispatch' do
        expect(result.item_event.dispatches.telegram.pending.count).to eq 1
      end
    end

    context 'when event_type is game_added' do
      let(:event_type) { ItemEventTypes::GAME_ADDED }

      it 'creates telegram event dispatch' do
        expect(result.item_event.dispatches.telegram.pending.count).to eq 1
      end
    end

    context 'when event_type is price_added' do
      let(:event_type) { ItemEventTypes::PRICE_ADDED }

      it 'creates telegram event dispatch' do
        expect(result.item_event.dispatches.telegram.pending.count).to eq 1
      end
    end

    context 'when game isn`t featured and event type isn`t game_added or price_added' do
      let(:event_type) { (ItemEventTypes.list - [ItemEventTypes::GAME_ADDED, ItemEventTypes::PRICE_ADDED]).sample }

      it 'doesn`t telegram event dispatch' do
        expect(result.item_event.dispatches.telegram.pending.count).to eq 0
      end
    end
  end
end
