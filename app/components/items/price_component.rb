# frozen_string_literal: true

module Items
  class PriceComponent < ViewComponent::Base
    attr_reader :price

    def initialize(price)
      @price = price
    end
  end
end
