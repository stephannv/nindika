# frozen_string_literal: true

class Items::CardComponent < ViewComponent::Base
  with_collection_parameter :item

  attr_reader :item

  def initialize(item:)
    @item = item
  end
end
