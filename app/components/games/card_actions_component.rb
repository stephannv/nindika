# frozen_string_literal: true

module Games
  class CardActionsComponent < ViewComponent::Base
    attr_reader :game, :current_user

    def initialize(game:, current_user:)
      @game = game
      @current_user = current_user
    end

    def dropdown_id
      "dropdown-#{game.id}"
    end

    def feature_checkbox_id
      "checkbox-#{game.id}"
    end

    def render?
      current_user.try(:admin?)
    end
  end
end
