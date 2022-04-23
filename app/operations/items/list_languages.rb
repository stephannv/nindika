# frozen_string_literal: true

module Items
  class ListLanguages < Actor
    output :languages, type: Array

    def call
      self.languages = Rails.cache.fetch('cache-languages', expires_in: 8.hours) do
        Item.pluck(:languages).flatten.uniq.compact.sort
      end
    end
  end
end
