# frozen_string_literal: true

module Items
  class Find < Actor
    input :slug, type: String
    input :current_user, type: User, allow_nil: true, default: nil

    output :item, type: Item

    def call
      scope = Item.friendly
      scope = scope.with_wishlisted_column(user_id: current_user.id) if current_user.present?
      self.item = scope.find(slug)
    end
  end
end
