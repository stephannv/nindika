# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RawItems::Fetch, type: :action do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it 'injects nintendo document repository dependency' do
      expect(inputs[:document_repository][:default].call).to be_a(Nintendo::DocumentRepository)
    end
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(raw_items_data: { type: Array }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(document_repository: document_repository) }

    let(:document_repository) { Nintendo::DocumentRepository.new }
    let(:items_a) { [{ objectID: '1' }, { objectID: '2' }] }
    let(:items_b) { [{ objectID: '2' }, { objectID: '3' }] }
    let(:items_c) { [{ objectID: '3' }, { objectID: '4' }] }

    before do
      allow(document_repository).to receive(:search).and_return([])
      allow(document_repository).to receive(:search).with('a').and_return(items_a)
      allow(document_repository).to receive(:search).with('b').and_return(items_b)
      allow(document_repository).to receive(:search).with('c').and_return(items_c)
    end

    it 'queries items with a-z and 0-9 characters' do
      (('a'..'z').to_a + ('0'..'9').to_a).each do |term|
        expect(document_repository).to receive(:search).with(term)
      end

      result
    end

    it 'returns items distincting by objectID' do
      expected_response = [{ objectID: '1' }, { objectID: '2' }, { objectID: '3' }, { objectID: '4' }]

      expect(result.raw_items_data).to eq expected_response
    end
  end
end
