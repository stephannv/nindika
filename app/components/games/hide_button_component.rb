# frozen_string_literal: true

module Games
  class HideButtonComponent < ViewComponent::Base
    attr_reader :game, :current_user

    def initialize(game:, current_user:)
      @game = game
      @current_user = current_user
    end

    def hidden?
      current_user.present? && current_user.hidden_list.exists?(id: game.id)
    end
  end
end
