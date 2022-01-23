# frozen_string_literal: true

module Items
  class Update < Actor
    input :id, type: String
    input :attributes, type: Hash

    output :item, type: Item

    def call
      self.item = Item.find(id)
      item.update!(attributes)
    end
  end
end
