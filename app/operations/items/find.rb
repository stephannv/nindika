# frozen_string_literal: true

module Items
  class Find < Actor
    input :slug, type: String
    input :current_user, type: User, default: nil

    output :item, type: Item

    def call
      self.item = item_relation.friendly.find(slug)
    end

    private

    def item_relation
      current_user.present? ? Item.with_wishlisted_column(user_id: current_user.id) : Item
    end
  end
end
