# frozen_string_literal: true

class ItemEventTypes < EnumerateIt::Base
  associate_values(
    :game_added,
    :price_added,
    :discount,
    :permanent_price_change,
    :price_state_change
  )

  class GameAdded
    def emoji
      @emoji ||= "✨"
    end
  end

  class PriceAdded
    def emoji
      @emoji ||= "💰"
    end
  end

  class Discount
    def emoji
      @emoji ||= "🤑"
    end
  end

  class PermanentPriceChange
    def emoji
      @emoji ||= "🔧"
    end
  end

  class PriceStateChange
    def emoji
      @emoji ||= "❌"
    end
  end
end
