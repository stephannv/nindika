# frozen_string_literal: true

class PriceStates < EnumerateIt::Base
  associate_values(
    :pre_order,
    :on_sale,
    :unavailable,
    :unreleased
  )
end
