# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceHistoryChartDataBuilder, type: :lib do
  describe '#build' do
    subject(:price_history_data) { described_class.build(relation: price.history_items) }

    let(:price) { create(:price) }
    let!(:history_item_b) { create(:price_history_item, price: price, reference_date: Time.zone.today) }
    let!(:history_item_c) { create(:price_history_item, price: price, reference_date: 1.month.from_now) }
    let!(:history_item_a) { create(:price_history_item, price: price, reference_date: 1.month.ago) }

    it 'returns history items data ordered by reference_date with x as reference date and y as amount' do
      expect(price_history_data).to eq [
        { x: 1.month.ago.to_date.iso8601, y: history_item_a.amount.to_f },
        { x: Time.zone.today.iso8601, y: history_item_b.amount.to_f },
        { x: 1.month.from_now.to_date.iso8601, y: history_item_c.amount.to_f }
      ]
    end
  end
end
