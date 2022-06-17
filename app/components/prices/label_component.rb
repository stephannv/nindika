# frozen_string_literal: true

module Prices
  class LabelComponent < ViewComponent::Base
    def initialize(money:, force_float: false)
      @money = money
      @force_float = force_float
    end

    private

    attr_reader :money

    def amount
      if force_float? || money.cents < 100
        money.format(symbol: false)
      else
        money.to_i
      end
    end

    def force_float?
      @force_float
    end
  end
end
