# frozen_string_literal: true

module Games
  class PriceComponent < ViewComponent::Base
    attr_reader :game, :price

    def initialize(game:)
      @game = game
    end

    def document
      game.document
    end

    def price?
      document.current_amount_display.present?
    end

    def on_sale?
      document.on_sale
    end
  end
end
