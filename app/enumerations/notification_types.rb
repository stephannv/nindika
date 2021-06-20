# frozen_string_literal: true

class NotificationTypes < EnumerateIt::Base
  associate_values(
    :price_uncovered,
    :discounted_price,
    :price_readjustment,
    :pre_order_discount
  )
end
