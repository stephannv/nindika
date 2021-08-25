# frozen_string_literal: true

module ItemEvents
  class Create < Actor
    input :item, type: Item
    input :price, type: Price, allow_nil: true, default: nil
    input :event_type, type: String, in: ItemEventTypes.list

    output :item_event, type: ItemEvent

    def call
      self.item_event = item.events.create!(
        event_type: event_type,
        title: item.title,
        url: Rails.application.routes.url_helpers.game_url(item),
        data: data
      )
      create_telegram_dispatch
    end

    private

    def data
      ItemEventDataBuilder.build(event_type: event_type, item: item, price: price)
    end

    def create_telegram_dispatch
      item_event.dispatches.create!(provider: EventDispatchProviders::TELEGRAM)
    end
  end
end
