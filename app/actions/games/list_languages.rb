# frozen_string_literal: true

module Games
  class ListLanguages < Actor
    output :languages, type: Array

    def call
      self.languages = Game.pluck(:languages).flatten.uniq.sort
    end
  end
end
