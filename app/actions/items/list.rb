# frozen_string_literal: true

module Items
  class List < Actor
    input :filter_params, type: [Hash, ActionController::Parameters], default: {}, allow_nil: true
    input :sort_param, type: String, default: nil, allow_nil: true
    input :current_user, type: User, allow_nil: true, default: nil

    output :items, type: Enumerable

    def call
      self.items = build_scope
    end

    private

    def build_scope
      scope = Item.left_joins(:price).includes(:price)
      scope = ItemsFilter.apply(scope, filter_params)
      scope = ItemsSorter.apply(scope, sort_param)
      if current_user.present?
        scope = scope.with_wishlisted_column(user_id: current_user.id)
        scope = scope.without_hidden(user_id: current_user.id)
      end
      scope
    end
  end
end
