# frozen_string_literal: true

module HiddenGames
  class Destroy < Actor
    input :user, type: User
    input :game_id, type: String

    def call
      hidden_game = user.hidden_games.find_by(game_id: game_id)

      fail!(error: :cannot_destroy) unless hidden_game.try(:destroy)
    end
  end
end
