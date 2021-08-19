# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::List, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(sort_param: { type: String, default: nil, allow_nil: true }) }
    it { is_expected.to include(user: { type: User, default: nil, allow_nil: true }) }

    it do
      filters_form = inputs.dig(:filters_form, :default).call
      expect(filters_form).to be_a(GameFiltersForm)
    end
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(items: { type: Enumerable }) }
  end

  describe '#call' do
    context 'when filter params is present' do
      let!(:item_on_sale) { create(:item, on_sale: true) }
      let(:filters_form) { GameFiltersForm.build(on_sale: true) }

      before { create(:item, on_sale: false) }

      it 'filters items' do
        result = described_class.result(filters_form: filters_form)

        expect(result.items.to_a).to eq [item_on_sale]
      end
    end

    context 'when sort param is present' do
      let!(:item_a) { create(:item, release_date: Time.zone.today) }
      let!(:item_b) { create(:item, release_date: Time.zone.tomorrow) }
      let!(:item_c) { create(:item, release_date: Time.zone.yesterday) }

      it 'sorts items' do
        result = described_class.result(sort_param: 'release_date_asc')

        expect(result.items.to_a).to eq [item_c, item_a, item_b]
      end
    end

    context 'when user is present' do
      it 'adds wishlisted column' do
        create(:item)
        result = described_class.result(user: User.new(id: Faker::Internet.uuid))

        expect(result.items.first).to respond_to :wishlisted
      end
    end

    context 'when include_hidden filter is filled' do
      let!(:hidden_item) { create(:hidden_item) }
      let!(:not_hidden_item) { create(:item) }

      let(:filters_form) { GameFiltersForm.build(include_hidden: true) }

      it 'returns items including hidden items' do
        result = described_class.result(user: hidden_item.user, filters_form: filters_form)

        expect(result.items).to include(hidden_item.item, not_hidden_item)
      end
    end

    context 'when only_hidden filter is filled' do
      let!(:hidden_item) { create(:hidden_item) }
      let(:filters_form) { GameFiltersForm.build(only_hidden: true) }

      before { create(:item) }

      it 'returns only hidden items' do
        result = described_class.result(user: hidden_item.user, filters_form: filters_form)

        expect(result.items).to eq [hidden_item.item]
      end
    end

    context 'when filter by user wishlist' do
      let!(:wishlist_item) { create(:wishlist_item) }
      let(:filters_form) { GameFiltersForm.build(wishlisted: true) }

      before do
        create(:wishlist_item) # creates item wishlisted by other user
        create(:item) # not wishlisted item
      end

      it 'returns only games present in user wishlist' do
        result = described_class.result(user: wishlist_item.user, filters_form: filters_form)

        expect(result.items.to_a).to eq [wishlist_item.item]
      end
    end
  end
end
