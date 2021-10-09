# frozen_string_literal: true

module GameEvents
  class List < Actor
    output :game_events, type: Enumerable

    def call
      order_query = Arel.sql("date_trunc('hour', created_at) DESC, event_type, title ASC")
      self.game_events = GameEvent.order(order_query)
    end
  end
end
