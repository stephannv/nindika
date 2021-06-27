# frozen_string_literal: true

module Items
  class WithWishlistedColumnQuery
    attr_reader :relation, :user_id

    def self.call(user_id:, relation: Item)
      new(relation: relation, user_id: user_id).call
    end

    def initialize(user_id:, relation: Item)
      @relation = relation
      @user_id = user_id
    end

    def call
      left_join_with_user_wishlist = <<-SQL.squish
        LEFT JOIN wishlist_items
        ON wishlist_items.item_id = items.id and wishlist_items.user_id = '#{user_id}'
      SQL

      relation
        .select('items.*', 'wishlist_items.id IS NOT NULL AS wishlisted')
        .joins(left_join_with_user_wishlist)
    end
  end
end
