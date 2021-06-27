# frozen_string_literal: true

module Games
  class PriceComponent < ViewComponent::Base
    attr_reader :game, :price

    def initialize(game:)
      @game = game
      @price = game.price
    end
  end
end
