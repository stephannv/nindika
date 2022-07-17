# frozen_string_literal: true

module WishlistItems
  class Destroy < Actor
    input :user, type: User
    input :item_id, type: String

    def call
      wishlist_item = user.wishlist_items.find_by(item_id: item_id)
      fail! unless wishlist_item&.destroy
    end
  end
end
