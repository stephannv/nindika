# frozen_string_literal: true

module Games
  module Card
    class PriceComponent < ViewComponent::Base
      def initialize(game:)
        @game = game
      end

      private

      attr_accessor :game
    end
  end
end
