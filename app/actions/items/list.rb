# frozen_string_literal: true

module Items
  class List < Actor
    input :filter_params, type: Hash, default: {}
    input :sort_param, type: String, default: nil, allow_nil: true
    input :user, type: User, allow_nil: true, default: nil

    output :items, type: Enumerable

    def call
      self.items = build_scope
    end

    private

    def build_scope
      scope = Item.left_joins(:price).includes(:price)
      scope = ItemsFilter.apply(scope, filter_params)
      scope = ItemsSorter.apply(scope, sort_param)
      scope = apply_wishlist_scope(scope)
      apply_hidden_scope(scope)
    end

    def apply_wishlist_scope(scope)
      return scope if user.blank?

      Items::WithWishlistedColumnQuery.call(
        relation: scope,
        user_id: user.id,
        only_wishlisted: filter_params[:wishlisted]
      )
    end

    def apply_hidden_scope(scope)
      return scope if user.blank?

      Items::WithoutHiddenQuery.call(relation: scope, user_id: user.id)
    end
  end
end
