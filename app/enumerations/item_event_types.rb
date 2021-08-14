# frozen_string_literal: true

class ItemEventTypes < EnumerateIt::Base
  associate_values(
    :game_added,
    :price_added,
    :discount,
    :permanent_price_change,
    :price_state_change
  )
end
