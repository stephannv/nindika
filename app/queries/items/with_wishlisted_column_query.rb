# frozen_string_literal: true

module Items
  class WithWishlistedColumnQuery
    attr_reader :relation, :user_id, :only_wishlisted

    def self.call(user_id:, relation: Item, only_wishlisted: false)
      new(relation: relation, user_id: user_id, only_wishlisted: only_wishlisted).call
    end

    def initialize(user_id:, relation: Item, only_wishlisted: false)
      @relation = relation
      @user_id = user_id
      @only_wishlisted = only_wishlisted
    end

    def call
      join_with_user_wishlist = <<-SQL.squish
        #{join_clause} JOIN wishlist_items
        ON wishlist_items.item_id = items.id and wishlist_items.user_id = '#{user_id}'
      SQL

      relation
        .select("items.*", "wishlist_items.id IS NOT NULL AS wishlisted")
        .joins(join_with_user_wishlist)
    end

    private

    def join_clause
      only_wishlisted ? :inner : :left
    end
  end
end
