# frozen_string_literal: true

class Items::PriceLabelComponent < ViewComponent::Base
  attr_reader :money

  def initialize(money:, line_through: false, force_float: false)
    @money = money
    @line_through = line_through
    @force_float = force_float
  end

  def value
    if force_float? || money.cents < 100
      money.format(symbol: false)
    else
      money.to_i
    end
  end

  def line_through?
    @line_through
  end

  def force_float?
    @force_float
  end
end
