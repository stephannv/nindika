# frozen_string_literal: true

module Games
  module Card
    class BannerComponent < ViewComponent::Base
      def initialize(game:)
        @game = game
      end

      private

      attr_reader :game

      def render?
        game.on_sale? || game.pre_order? || game.new_release?
      end

      def text
        return t(".on_sale") if game.on_sale?
        return t(".pre_order") if game.pre_order?
        return t(".new_release") if game.new_release?
      end

      def gradient_class
        return "gradient-teal" if game.on_sale?
        return "gradient-pink" if game.pre_order?
        return "gradient-purple" if game.new_release?
      end
    end
  end
end
