# frozen_string_literal: true

module Items
  class ListGenres < Actor
    output :genres, type: Array

    def call
      self.genres = Item.pluck(:genres).flatten.uniq.sort
    end
  end
end
