# frozen_string_literal: true

module Games
  class ListGenres < Actor
    output :genres, type: Array

    def call
      self.genres = Game.pluck(:genres).flatten.uniq.sort
    end
  end
end
