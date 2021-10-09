# frozen_string_literal: true

module WishlistGames
  class Create < Actor
    input :user, type: User
    input :game_id, type: String

    output :wishlist_game, type: WishlistGame

    def call
      self.wishlist_game = user.wishlist_games.new(game_id: game_id)

      fail!(error: :invalid_record) unless wishlist_game.save
    end
  end
end
