# frozen_string_literal: true

module Items
  class Find < Actor
    input :slug, type: String
    input :user, type: User, allow_nil: true, default: nil

    output :item, type: Item

    def call
      scope = Item.friendly
      scope = Items::WithWishlistedColumnQuery.call(relation: scope, user_id: user.id) if user.present?
      self.item = scope.find(slug)
    end
  end
end
