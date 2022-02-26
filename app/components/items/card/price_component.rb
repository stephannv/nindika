# frozen_string_literal: true

class Items::Card::PriceComponent < ViewComponent::Base
  attr_reader :item, :price

  def initialize(item:)
    @item = item
    @price = item.price
  end
end
