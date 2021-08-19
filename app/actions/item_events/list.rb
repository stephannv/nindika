# frozen_string_literal: true

module ItemEvents
  class List < Actor
    output :item_events, type: Enumerable

    def call
      order_query = Arel.sql("date_trunc('hour', created_at) DESC, event_type, title ASC")
      self.item_events = ItemEvent.order(order_query)
    end
  end
end
