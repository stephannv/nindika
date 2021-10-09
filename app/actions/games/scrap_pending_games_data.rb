# frozen_string_literal: true

module Games
  class ScrapPendingGamesData < Actor
    def call
      Game.pending_scrap.find_each(batch_size: 200) do |game|
        Games::ScrapData.call(game: game)
      rescue StandardError => e
        raise e if Rails.env.development?

        Sentry.capture_exception(e, extra: { game_id: game.id })
      end
    end
  end
end
