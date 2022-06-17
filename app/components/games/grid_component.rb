# frozen_string_literal: true

module Games
  class GridComponent < ViewComponent::Base
    def initialize(games:)
      @games = games
    end

    private

    attr_reader :games
  end
end
