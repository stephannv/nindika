# frozen_string_literal: true

module Games
  class PriceWithCTAButtonComponent < ViewComponent::Base
    attr_reader :price

    def initialize(price:)
      @price = price
    end

    def cta_button_label
      if price.current_price.zero?
        t('.free_download')
      else
        t('.buy_now')
      end
    end

    def render?
      price.present?
    end
  end
end
