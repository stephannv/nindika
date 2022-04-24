# frozen_string_literal: true

module Items
  class Find < Actor
    input :slug, type: String

    output :item, type: Item

    def call
      self.item = Item.friendly.find(slug)
    end
  end
end
