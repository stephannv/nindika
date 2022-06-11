# frozen_string_literal: true

class Items::Details::PriceCardComponent < ViewComponent::Base
  attr_reader :item, :price

  def initialize(item:)
    @item = item
    @price = item.price
  end

  def price?
    price.present?
  end

  def button_text
    if price&.current_price&.zero?
      t(".free_download")
    else
      t(".buy_now")
    end
  end
end
