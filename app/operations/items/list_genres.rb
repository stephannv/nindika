# frozen_string_literal: true

module Items
  class ListGenres < Actor
    output :genres, type: Array

    def call
      self.genres = Rails.cache.fetch("cache-genres", expires_in: 8.hours) do
        Item.pluck(:genres).flatten.uniq.sort
      end
    end
  end
end
