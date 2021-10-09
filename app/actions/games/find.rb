# frozen_string_literal: true

module Games
  class Find < Actor
    input :slug, type: String
    input :user, type: User, allow_nil: true, default: nil

    output :game, type: Game

    def call
      scope = Game.friendly
      if user.present?
        scope = Games::WithWishlistedColumnQuery.call(relation: scope, user_id: user.id)
        scope = Games::WithHiddenColumnQuery.call(relation: scope, user_id: user.id, include_hidden: true)
      end
      self.game = scope.find(slug)
    end
  end
end
