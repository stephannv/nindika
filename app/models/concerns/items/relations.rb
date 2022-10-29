# frozen_string_literal: true

require "active_support/concern"

module Items
  module Relations
    extend ActiveSupport::Concern

    included do
      has_one :raw_item, dependent: :destroy
      has_one :price, dependent: :destroy

      has_many :wishlist_items, dependent: :destroy
      has_many :parent_relationships,
        class_name: "ItemRelationship",
        foreign_key: :parent_id,
        dependent: :destroy,
        inverse_of: :parent
      has_many :child_relationships,
        class_name: "ItemRelationship",
        foreign_key: :child_id,
        dependent: :destroy,
        inverse_of: :child

      has_many :children, through: :parent_relationships, class_name: "Item", source: :child
      has_many :parents, through: :child_relationships, class_name: "Item", source: :parent
      has_many :price_history_items, through: :price, source: :history_items
    end
  end
end
