# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RawItems::FetchAll, type: :action do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it 'injects nintendo algolia client dependency' do
      expect(inputs[:client][:default].call).to be_a(NintendoAlgoliaClient)
    end
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(raw_items_data: { type: Array }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(client: client) }

    let(:client) { NintendoAlgoliaClient.new }
    let(:items_a) { [{ objectID: '1', _highlightResult: 'foo' }, { objectID: '2', _highlightResult: 'foo' }] }
    let(:items_b) { [{ objectID: '2', _highlightResult: 'foo' }, { objectID: '3', _highlightResult: 'foo' }] }
    let(:items_c) { [{ objectID: '3', _highlightResult: 'foo' }, { objectID: '4', _highlightResult: 'foo' }] }

    before do
      allow(RawItems::FetchUsingQueryTerm).to receive(:result)
        .and_return(ServiceActor::Result.new(raw_items_data: []))
      allow(RawItems::FetchUsingQueryTerm).to receive(:result)
        .with(client: client, query_term: 'a')
        .and_return(ServiceActor::Result.new(raw_items_data: items_a))
      allow(RawItems::FetchUsingQueryTerm).to receive(:result)
        .with(client: client, query_term: 'b')
        .and_return(ServiceActor::Result.new(raw_items_data: items_b))
      allow(RawItems::FetchUsingQueryTerm).to receive(:result)
        .with(client: client, query_term: 'c')
        .and_return(ServiceActor::Result.new(raw_items_data: items_c))
    end

    it 'queries items with a-z and 0-9 characters' do
      (('a'..'z').to_a + ('0'..'9').to_a).each do |term|
        expect(RawItems::FetchUsingQueryTerm).to receive(:result).with(client: client, query_term: term)
      end

      result
    end

    it 'returns items distincting by objectID and removing _highlightResult attribute' do
      expect(result.raw_items_data).to eq [
        { objectID: '1' }, { objectID: '2' }, { objectID: '3' }, { objectID: '4' }
      ]
    end
  end
end
