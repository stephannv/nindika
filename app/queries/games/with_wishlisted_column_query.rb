# frozen_string_literal: true

module Games
  class WithWishlistedColumnQuery
    attr_reader :relation, :user_id, :only_wishlisted

    def initialize(user_id:, relation: Game, only_wishlisted: false)
      @relation = relation
      @user_id = user_id
      @only_wishlisted = only_wishlisted
    end

    def self.call(...)
      new(...).call
    end

    def call
      join_with_user_wishlist = <<-SQL.squish
        #{join_clause} JOIN wishlist_games
        ON wishlist_games.game_id = games.id and wishlist_games.user_id = '#{user_id}'
      SQL

      relation
        .select('games.*', 'wishlist_games.id IS NOT NULL AS wishlisted')
        .joins(join_with_user_wishlist)
    end

    private

    def join_clause
      only_wishlisted ? :inner : :left
    end
  end
end
