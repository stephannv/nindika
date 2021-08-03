# frozen_string_literal: true

module Prices
  class CreateHistoryItem < Actor
    input :price, type: Price

    def call
      fail!(error: 'Price didn`t change') unless price.saved_change_to_current_price?

      price_history_item = price.history_items.find_or_initialize_by(reference_date: Time.zone.today)
      price_history_item.amount = price.current_price
      price_history_item.save!
    end
  end
end
