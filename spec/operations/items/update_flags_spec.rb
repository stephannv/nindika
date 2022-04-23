# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::UpdateFlags, type: :operations do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    context 'when item is marked as on sale but its price doesn`t have discount' do
      let!(:item) { create(:item, on_sale: true, price: create(:price)) }

      it 'sets on sale to false' do
        result

        expect(item.reload).not_to be_on_sale
      end
    end

    context 'when item isn`t marked as on sale but its price has discount' do
      let!(:item) { create(:item, on_sale: false, price: create(:price, :with_discount)) }

      it 'sets on sale to true' do
        result

        expect(item.reload).to be_on_sale
      end
    end

    context 'when item is marked as coming soon but already launched' do
      let!(:item) { create(:item, coming_soon: true, release_date: Time.zone.today) }

      it 'sets coming soon to false' do
        result

        expect(item.reload).not_to be_coming_soon
      end
    end

    context 'when item isn`t marked as coming soon but releases in the next two weeks' do
      let!(:item) { create(:item, coming_soon: true, release_date: Faker::Date.forward(days: 14)) }

      it 'sets coming soon to true' do
        result

        expect(item.reload).to be_coming_soon
      end
    end

    context 'when item is marked as new release but is a old release' do
      let!(:item) { create(:item, new_release: true, release_date: 15.days.ago) }

      it 'sets new release to false' do
        result

        expect(item.reload).not_to be_new_release
      end
    end

    context 'when item isn`t marked as new release but was released in the past 2 weeks' do
      let!(:item) { create(:item, new_release: false, release_date: Faker::Date.backward(days: 14)) }

      it 'sets new release to true' do
        result

        expect(item.reload).to be_new_release
      end
    end

    context 'when item is marked as pre order but isn`t in pre order' do
      let!(:item) { create(:item, pre_order: true, price: create(:price, :on_sale)) }

      it 'sets pre order to false' do
        result

        expect(item.reload).not_to be_pre_order
      end
    end

    context 'when item isn`t marked as pre order but it is in pre order' do
      let!(:item) { create(:item, pre_order: false, price: create(:price, :pre_order)) }

      it 'sets pre order to true' do
        result

        expect(item.reload).to be_pre_order
      end
    end
  end
end
