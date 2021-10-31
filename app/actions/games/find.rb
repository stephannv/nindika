# frozen_string_literal: true

module Games
  class Find < Actor
    input :slug, type: String

    output :game, type: Game

    def call
      self.game = Game.friendly.find(slug)
    end
  end
end
