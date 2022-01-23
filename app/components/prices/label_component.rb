# frozen_string_literal: true

module Prices
  class LabelComponent < ViewComponent::Base
    attr_reader :money

    def initialize(money:, line_through: false)
      @money = money
      @line_through = line_through
    end

    def value
      if money.cents < 100
        money.format(symbol: false)
      else
        money.to_i
      end
    end

    def line_through?
      @line_through
    end
  end
end
