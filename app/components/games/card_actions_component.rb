# frozen_string_literal: true

module Games
  class CardActionsComponent < ViewComponent::Base
    attr_reader :game

    def initialize(game:)
      @game = game
    end

    def dropdown_id
      "dropdown-#{game.id}"
    end
  end
end
