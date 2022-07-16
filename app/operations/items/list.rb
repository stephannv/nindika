# frozen_string_literal: true

module Items
  class List < Actor
    input :filters_form, type: GameFiltersForm, default: -> { GameFiltersForm.new }
    input :sort_param, type: String, default: nil, allow_nil: true
    input :current_user, type: User, default: nil

    output :items, type: Enumerable

    def call
      self.items = build_scope
    end

    private

    def build_scope
      scope = default_item_scope
      scope = apply_filters(scope)
      scope = apply_wishlist_column(scope) if current_user.present?
      apply_sort(scope)
    end

    def default_item_scope
      Item.only_games.including_prices
    end

    def apply_filters(scope)
      ItemsFilter.apply(relation: scope, filters_form: filters_form)
    end

    def apply_wishlist_column(scope)
      scope.with_wishlisted_column(user_id: current_user.id, only_wishlisted: filters_form.wishlisted)
    end

    def apply_sort(scope)
      ItemsSorter.apply(relation: scope, param: sort_param)
    end
  end
end
