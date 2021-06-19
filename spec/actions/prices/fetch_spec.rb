# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Prices::Fetch, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it 'injects nintendo prices client dependency' do
      expect(inputs[:client][:default].call).to be_a(NintendoPricesClient)
    end
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(prices_data: { type: Array }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(client: client) }

    let(:client) { NintendoPricesClient.new }
    let(:items) { create_list(:item, 2) }
    let(:nsuids) { items.map(&:nsuid) }
    let(:prices_data) { [double] }

    before do
      create_list(:item, 2, nsuid: nil)
      allow(client).to receive(:fetch)
        .with(country: 'BR', lang: 'pt', nsuids: a_collection_containing_exactly(*nsuids))
        .and_return(prices_data)
    end

    it 'fetch prices from items with nsuid' do
      expect(result.prices_data).to eq prices_data
    end
  end
end
