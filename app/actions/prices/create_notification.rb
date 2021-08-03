# frozen_string_literal: true

module Prices
  class CreateNotification < Actor
    input :price, type: Price

    def call
      fail!(error: 'Price didn`t change') unless price.saved_change_to_current_price?

      data = ::PriceNotificationDataBuilder.build(price: price)
      price.item.notifications.create!(data) if data
    end
  end
end
