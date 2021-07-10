# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nintendo::PriceDataAdapter, type: :data_adapter do
  subject(:adapted_data) { described_class.adapt(base_data.merge(data)) }

  let(:base_data) { { 'sales_status' => 'onsale' } }
  let(:data) { {} }
  let(:discount_data) do
    {
      'price' => {
        'regular_price' => {
          'raw_value' => 50,
          'currency' => 'BRL'
        },
        'discount_price' => {
          'raw_value' => 20,
          'currency' => 'BRL',
          'start_datetime' => Time.zone.yesterday.to_s,
          'end_datetime' => Time.zone.tomorrow.to_s
        }
      }
    }
  end

  describe '#country_code' do
    it 'returns `BR`' do
      expect(adapted_data[:country_code]).to eq 'BR'
    end
  end

  describe '#nsuid' do
    let(:data) { { 'id' => '1234' } }

    it 'returns id' do
      expect(adapted_data[:nsuid]).to eq '1234'
    end
  end

  describe '#base_price' do
    context 'when base price is present' do
      let(:data) { { 'price' => { 'regular_price' => { 'raw_value' => 50, 'currency' => 'BRL' } } } }

      it 'returns base price as money object' do
        expect(adapted_data[:base_price]).to eq Money.new(5000, 'BRL')
      end
    end

    context 'when base price is nil' do
      let(:data) { { 'price' => { 'regular_price' => nil } } }

      it 'returns nil' do
        expect(adapted_data[:base_price]).to be_nil
      end
    end
  end

  describe '#discount_price' do
    context 'when discount price is present' do
      let(:data) { discount_data }

      it 'returns discount price as money object' do
        expect(adapted_data[:discount_price]).to eq Money.new(2000, 'BRL')
      end
    end

    context 'when discount price is nil' do
      let(:data) { { 'price' => { 'discount_price' => nil } } }

      it 'returns nil' do
        expect(adapted_data[:discount_price]).to be_nil
      end
    end
  end

  describe '#discount_started_at' do
    context 'when discount price is present' do
      let(:data) { discount_data }

      it 'returns discount start date as date object' do
        expect(adapted_data[:discount_started_at]).to eq Time.zone.yesterday.beginning_of_day
      end
    end

    context 'when discount price is nil' do
      let(:data) { { 'price' => { 'discount_price' => nil } } }

      it 'returns nil' do
        expect(adapted_data[:discount_started_at]).to be_nil
      end
    end
  end

  describe '#discount_ends_at' do
    context 'when discount price is present' do
      let(:data) { discount_data }

      it 'returns discount end date as date object' do
        expect(adapted_data[:discount_ends_at]).to eq Time.zone.tomorrow.beginning_of_day
      end
    end

    context 'when discount price is nil' do
      let(:data) { { 'price' => { 'discount_price' => nil } } }

      it 'returns nil' do
        expect(adapted_data[:discount_ends_at]).to be_nil
      end
    end
  end

  describe '#state' do
    let(:data) { { 'sales_status' => sales_status } }

    %w[not_found not_sale sales_termination].each do |state|
      context "when state status is #{state}" do
        let(:sales_status) { state }

        it 'returns PriceStates::UNAVAILABLE' do
          expect(adapted_data[:state]).to eq PriceStates::UNAVAILABLE
        end
      end
    end

    context 'when state status is onsale' do
      let(:sales_status) { 'onsale' }

      it 'returns PriceStates::ON_SALE' do
        expect(adapted_data[:state]).to eq PriceStates::ON_SALE
      end
    end

    %w[pre_order preorder].each do |state|
      context "when state status is #{state}" do
        let(:sales_status) { state }

        it 'returns PriceStates::PRE_ORDER' do
          expect(adapted_data[:state]).to eq PriceStates::PRE_ORDER
        end
      end
    end

    context 'when state status is unreleased' do
      let(:sales_status) { 'unreleased' }

      it 'returns PriceStates::UNRELEASED' do
        expect(adapted_data[:state]).to eq PriceStates::UNRELEASED
      end
    end

    context 'when state is not mapped' do
      let(:sales_status) { Faker::Lorem.word }

      it 'raises error' do
        expect { adapted_data[:state] }.to raise_error("#{sales_status} NOT MAPPED PRICE STATE")
      end
    end
  end

  describe '#gold_points' do
    let(:data) { { 'price' => { 'gold_point' => { 'gift_gp' => 123 } } } }

    it 'returns gift_gp' do
      expect(adapted_data[:gold_points]).to eq 123
    end
  end
end
