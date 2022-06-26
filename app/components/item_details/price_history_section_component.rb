# frozen_string_literal: true

class ItemDetails::PriceHistorySectionComponent < ViewComponent::Base
  def initialize(item:)
    @item = item
  end

  private

  attr_reader :item
end
