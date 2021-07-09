# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nintendo::DocumentRepository, type: :lib do
  describe '#search' do
    subject(:response) { described_class.new(client: client).search(term) }

    let(:client) { Nintendo::AlgoliaClient.new }
    let(:term) { Faker::Lorem.word }
    let(:items_a) { [{ objectID: '1', _highlightResult: 'foo' }, { objectID: '2', _highlightResult: 'foo' }] }
    let(:items_b) { [{ objectID: '2', _highlightResult: 'foo' }, { objectID: '3', _highlightResult: 'foo' }] }

    before do
      allow(client).to receive(:fetch)
        .with(index: client.index_asc, query: term)
        .and_return(items_a)
      allow(client).to receive(:fetch)
        .with(index: client.index_desc, query: term)
        .and_return(items_b)
    end

    context 'when asc index returns less than 500 items' do
      it 'returns found items using asc index' do
        expect(response).to eq [{ objectID: '1' }, { objectID: '2' }]
      end
    end

    context 'when asc index return more than 500 items' do
      before do
        allow(items_a).to receive(:size).and_return(600)
      end

      it 'returns found items using asc and desc index' do
        expect(response).to eq [{ objectID: '1' }, { objectID: '2' }, { objectID: '3' }]
      end
    end
  end
end
