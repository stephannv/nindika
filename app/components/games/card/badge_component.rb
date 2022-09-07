# frozen_string_literal: true

module Games
  module Card
    class BadgeComponent < ViewComponent::Base
      BASE_CLASSES = "absolute top-0 right-0 uppercase p-2 text-xs rounded-l-lg drop-shadow-lg
        font-black lg:font-bold border".squish

      COLOR_CLASSES = {
        coming_soon: "bg-[#5A94FF] text-white border-[#4876cc]",
        pre_order: "bg-[#C65AFF] text-white border-[#763699]",
        new_release: "bg-[#ADFF5A] text-black border-[#8acc48]"
      }.freeze

      def initialize(game:)
        @game = game
      end

      private

      attr_reader :game

      def render?
        type.present?
      end

      def type
        if game.pre_order? then :pre_order
        elsif game.coming_soon? then :coming_soon
        elsif game.new_release? then :new_release
        end
      end

      def text
        {
          coming_soon: t(".coming_soon"),
          pre_order: t(".pre_order"),
          new_release: t(".new_release")
        }[type]
      end

      def classes
        [BASE_CLASSES, COLOR_CLASSES[type]]
      end
    end
  end
end
