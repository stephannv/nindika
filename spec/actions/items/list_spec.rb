# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::List, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(filter_params: { type: Hash, default: {} }) }
    it { is_expected.to include(sort_param: { type: String, default: nil, allow_nil: true }) }
    it { is_expected.to include(user: { type: User, default: nil, allow_nil: true }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(items: { type: Enumerable }) }
  end

  describe '#call' do
    context 'when filter params is present' do
      let!(:item_on_sale) { create(:item, on_sale: true) }

      before { create(:item, on_sale: false) }

      it 'filters items' do
        result = described_class.result(filter_params: { on_sale: true })

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

      it 'doesn`t returns hidden items' do
        item = create(:item)
        hidden_item = create(:hidden_item, item: item)
        result = described_class.result(user: hidden_item.user)

        expect(result.items).to be_empty
      end
    end

    context 'when filter by user wishlist' do
      let!(:wishlist_item) { create(:wishlist_item) }

      before do
        create(:wishlist_item) # creates item wishlisted by other user
        create(:item) # not wishlisted item
      end

      it 'returns only games present in user wishlist' do
        result = described_class.result(user: wishlist_item.user, filter_params: { wishlisted: true })

        expect(result.items.to_a).to eq [wishlist_item.item]
      end
    end
  end
end
