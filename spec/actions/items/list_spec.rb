# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::List, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(search_term: { type: String, default: nil, allow_nil: true }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(items: { type: Enumerable }) }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    let!(:items) { create_list(:item, 5, :with_price) }

    it 'returns all items' do
      expect(result.items.to_a).to include(*items)
    end

    context 'when search term is present' do
      subject(:result) { described_class.result(search_term: 'leslie') }

      let!(:item) { create(:item, title: 'As confusões de Leslie') }

      before { create_list(:item, 5, :with_price) }

      it 'returns items filtering by title' do
        expect(result.items.to_a).to eq [item]
      end
    end
  end
end
