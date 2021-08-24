# frozen_string_literal: true

module Items
  class ListLanguages < Actor
    output :languages, type: Array

    def call
      self.languages = Item.pluck(:languages).flatten.uniq.sort
    end
  end
end
