# frozen_string_literal: true

module Games
  class CardComponent < ViewComponent::Base
    with_collection_parameter :game

    def initialize(game:)
      @game = game
    end

    private

    attr_reader :game
  end
end
