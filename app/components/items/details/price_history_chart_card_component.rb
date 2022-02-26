# frozen_string_literal: true

class Items::Details::PriceHistoryChartCardComponent < ViewComponent::Base
  attr_reader :item

  def initialize(item:)
    @item = item
  end
end
