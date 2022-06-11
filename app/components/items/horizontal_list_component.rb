# frozen_string_literal: true

class Items::HorizontalListComponent < ViewComponent::Base
  attr_reader :title, :items, :cards_size, :see_all_href

  def initialize(
    title:, items:, see_all_href:, cards_size: "uk-width-5-6 uk-width-2-3@m uk-width-1-4@l uk-width-1-5@xl"
  )
    @title = title
    @items = items
    @cards_size = cards_size
    @see_all_href = see_all_href
  end
end
