# frozen_string_literal: true

module Games
  class Find < Actor
    input :slug, type: String
    input :user, type: User, allow_nil: true, default: nil

    output :game, type: Game

    def call
      self.game = Game.friendly.find(slug)
    end
  end
end
