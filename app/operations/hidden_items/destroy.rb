# frozen_string_literal: true

module HiddenItems
  class Destroy < Actor
    input :user, type: User
    input :item_id, type: String

    def call
      hidden_item = user.hidden_items.find_by(item_id: item_id)

      fail!(error: :cannot_destroy) unless hidden_item.try(:destroy)
    end
  end
end
