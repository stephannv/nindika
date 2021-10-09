# frozen_string_literal: true

module HiddenGames
  class Create < Actor
    input :user, type: User
    input :game_id, type: String

    output :hidden_game, type: HiddenGame

    def call
      self.hidden_game = user.hidden_games.new(game_id: game_id)

      fail!(error: :invalid_record) unless hidden_game.save
    end
  end
end
