# frozen_string_literal: true

module HiddenItems
  class Create < Actor
    input :user, type: User
    input :item_id, type: String

    output :hidden_item, type: HiddenItem

    def call
      self.hidden_item = user.hidden_items.new(item_id: item_id)

      fail!(error: :invalid_record) unless hidden_item.save
    end
  end
end
