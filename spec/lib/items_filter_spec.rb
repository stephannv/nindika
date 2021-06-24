# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsFilter, type: :lib do
  describe '#apply' do
    let(:result) { described_class.apply(Item, params) }

    context 'when title param is present' do
      subject(:params) { { title: 'leslie' } }

      let!(:item) { create(:item, title: 'As confusões de Leslie') }

      before { create_list(:item, 3, :with_price) }

      it 'returns items filtering by title' do
        expect(result.to_a).to eq [item]
      end
    end

    context 'when on_sale param is true' do
      subject(:params) { { on_sale: true } }

      let!(:item) { create(:item, on_sale: true) }

      before { create_list(:item, 3, on_sale: false) }

      it 'returns items on sale' do
        expect(result.to_a).to eq [item]
      end
    end

    context 'when new_release param is true' do
      subject(:params) { { new_release: true } }

      let!(:item) { create(:item, new_release: true) }

      before { create_list(:item, 3, new_release: false) }

      it 'returns new releases items' do
        expect(result.to_a).to eq [item]
      end
    end

    context 'when coming_soon param is true' do
      subject(:params) { { coming_soon: true } }

      let!(:item) { create(:item, coming_soon: true) }

      before { create_list(:item, 3, coming_soon: false) }

      it 'returns coming soon items' do
        expect(result.to_a).to eq [item]
      end
    end

    context 'when pre_order param is true' do
      subject(:params) { { pre_order: true } }

      let!(:item) { create(:item, pre_order: true) }

      before { create_list(:item, 3, pre_order: false) }

      it 'returns pre order items' do
        expect(result.to_a).to eq [item]
      end
    end
  end
end
