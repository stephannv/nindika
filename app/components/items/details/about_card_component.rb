# frozen_string_literal: true

class Items::Details::AboutCardComponent < ViewComponent::Base
  attr_reader :item

  def initialize(item:)
    @item = item
  end
end
