# frozen_string_literal: true

module GameEvents
  class Create < Actor
    input :game, type: Game
    input :price, type: Price, allow_nil: true, default: nil
    input :event_type, type: String, in: GameEventTypes.list

    output :game_event, type: GameEvent

    def call
      self.game_event = game.events.create!(
        event_type: event_type,
        title: game.title,
        url: "#{App.config.app_domain}/game/#{game.slug}",
        data: data
      )
      create_telegram_dispatch
    end

    private

    def data
      GameEventDataBuilder.build(event_type: event_type, game: game, price: price)
    end

    def create_telegram_dispatch
      game_event.dispatches.create!(provider: EventDispatchProviders::TELEGRAM)
    end
  end
end
