# frozen_string_literal: true

module Games
  class HideButtonComponent < ViewComponent::Base
    attr_reader :game, :current_user

    def initialize(game:)
      @game = game
    end

    def hidden?
      game.try(:hidden)
    end
  end
end
