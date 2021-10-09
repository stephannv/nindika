# frozen_string_literal: true

module Games
  class List < Actor
    input :filters_form, type: GameFiltersForm, default: -> { GameFiltersForm.new }
    input :sort_param, type: String, default: nil, allow_nil: true
    input :user, type: User, allow_nil: true, default: nil

    output :games, type: Enumerable

    def call
      self.games = build_scope
    end

    private

    def build_scope
      scope = Game.left_joins(:price).includes(:price)
      scope = GamesFilter.apply(relation: scope, filters_form: filters_form)
      scope = GamesSorter.apply(relation: scope, param: sort_param)
      scope = apply_wishlist_scope(scope)
      apply_hidden_scope(scope)
    end

    def apply_wishlist_scope(scope)
      return scope if user.blank?

      Games::WithWishlistedColumnQuery.call(
        relation: scope,
        user_id: user.id,
        only_wishlisted: filters_form.wishlisted
      )
    end

    def apply_hidden_scope(scope)
      return scope if user.blank?

      Games::WithHiddenColumnQuery.call(
        relation: scope,
        user_id: user.id,
        include_hidden: filters_form.include_hidden,
        only_hidden: filters_form.only_hidden
      )
    end
  end
end
