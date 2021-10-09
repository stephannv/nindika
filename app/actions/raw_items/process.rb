# frozen_string_literal: true

module RawItems
  class Process < Actor
    def call
      RawItem.pending.find_each(batch_size: 200) do |raw_item|
        process_raw_item(raw_item)
      end
    end

    private

    def process_raw_item(raw_item)
      data = ::NintendoAlgoliaDataAdapter.adapt(raw_item.data)
      game = raw_item.game || Game.new
      game.assign_attributes(data)
      ActiveRecord::Base.transaction do
        game.save!
        GameEvents::Create.call(event_type: GameEventTypes::GAME_ADDED, game: game) if game.saved_change_to_id?
        raw_item.update!(game_id: game.id, imported: true)
      end
    rescue StandardError => e
      raise e if Rails.env.development?

      Sentry.capture_exception(e, extra: { raw_item: raw_item.data })
    end
  end
end
