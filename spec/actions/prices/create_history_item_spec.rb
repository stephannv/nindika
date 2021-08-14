# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Prices::CreateHistoryItem, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(price: { type: Price }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result(price: price) }

    let(:price) { create(:price) }

    context 'when price didn`t change current amount' do
      before { allow(price).to receive(:saved_change_to_current_price?).and_return(false) }

      it { is_expected.to be_success }

      it 'doesn`t create a new price history item' do
        expect { result }.not_to change(PriceHistoryItem, :count)
      end
    end

    context 'when price changes and already has history item referencing current date' do
      let!(:price_history_item) do
        create(:price_history_item, reference_date: Time.zone.today, amount: 0, price: price)
      end

      before do
        allow(price).to receive(:saved_change_to_current_price?).and_return(true)
      end

      it 'doesn`t create a new price history item' do
        expect { result }.not_to change(PriceHistoryItem, :count)
      end

      it 'updates existing price history item' do
        result

        expect(price_history_item.reload.amount).to eq price.current_price
      end
    end

    context 'when price changes and doesn`t have history item referencing current date' do
      it 'creates a new price history item' do
        expect { result }.to change(PriceHistoryItem, :count).by(1)
      end

      it 'updates existing price history item' do
        result

        expect(price.history_items.last.amount).to eq price.current_price
      end
    end
  end
end
