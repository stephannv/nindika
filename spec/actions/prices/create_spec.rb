# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Prices::Create, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(prices_data: { type: Array }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result(prices_data: [data]) }

    let(:item) { create(:item) }
    let(:adapted_data) { attributes_for(:price, nsuid: item.nsuid) }
    let(:data) { Faker::Types.rb_hash(number: 4) }

    before do
      allow(NintendoPriceDataAdapter).to receive(:adapt).with(data).and_return(adapted_data)
    end

    context 'when regular amount is nil' do
      before { adapted_data[:regular_amount] = nil }

      it 'doesn`t create price' do
        expect { result }.not_to change(Price, :count)
      end
    end

    context 'when nsuid isn`t taken' do
      it 'creates a new price' do
        expect { result }.to change(Price, :count).by(1)
      end

      it 'associates price with item with same nsuid' do
        result

        expect(Price.last.item).to eq item
      end

      it 'creates price with adapted data' do
        result

        expect(Price.last.attributes).to include(
          'nsuid' => adapted_data[:nsuid],
          'regular_amount_cents' => adapted_data[:regular_amount].cents,
          'regular_amount_currency' => adapted_data[:regular_amount].currency.iso_code,
          'state' => adapted_data[:state]
        )
      end

      it 'creates price history item' do
        expect(Prices::CreateHistoryItem).to receive(:result).with(price: an_instance_of(Price))

        result
      end

      it 'creates notification' do
        expect(Prices::CreateNotification).to receive(:result).with(price: an_instance_of(Price))

        result
      end
    end

    context 'when nsuid is taken' do
      let!(:price) { create(:price, nsuid: item.nsuid) }

      it 'doesn`t create price' do
        expect { result }.not_to change(Price, :count)
      end

      it 'doesn`t change associated price item' do
        expect { result }.not_to change(price, :item_id)
      end

      it 'updates price with adapted data' do
        result

        expect(price.reload.attributes).to include(
          'nsuid' => adapted_data[:nsuid],
          'regular_amount_cents' => adapted_data[:regular_amount].cents,
          'regular_amount_currency' => adapted_data[:regular_amount].currency.iso_code,
          'state' => adapted_data[:state]
        )
      end

      it 'creates price history item' do
        expect(Prices::CreateHistoryItem).to receive(:result).with(price: an_instance_of(Price))

        result
      end

      it 'creates notification' do
        expect(Prices::CreateNotification).to receive(:result).with(price: an_instance_of(Price))

        result
      end
    end

    context 'when some error happens on development environment' do
      let(:error) { StandardError.new('some error') }

      before do
        allow(Rails.env).to receive(:development?).and_return(true)
        allow(Price).to receive(:find_or_initialize_by).and_raise(error)
      end

      it 'raises error' do
        expect { result }.to raise_error(error)
      end
    end

    context 'when some error happens on not development environment' do
      let(:error) { StandardError.new('some error') }

      before do
        allow(Rails.env).to receive(:development?).and_return(false)
        allow(Price).to receive(:find_or_initialize_by).and_raise(error)
      end

      it 'handles error with Sentry' do
        expect(Sentry).to receive(:capture_exception).with(error, extra: data)

        result
      end
    end
  end
end
