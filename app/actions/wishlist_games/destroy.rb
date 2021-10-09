# frozen_string_literal: true

module WishlistGames
  class Destroy < Actor
    input :user, type: User
    input :game_id, type: String

    def call
      wishlist_game = user.wishlist_games.find_by(game_id: game_id)

      fail!(error: :cannot_destroy) unless wishlist_game.try(:destroy)
    end
  end
end
