# frozen_string_literal: true

module Games
  class CardComponent < ViewComponent::Base
    with_collection_parameter :game

    attr_reader :game, :current_user

    def initialize(game:, current_user:)
      @game = game
      @current_user = current_user
    end
  end
end
