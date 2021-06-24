# frozen_string_literal: true

module Items
  class List < Actor
    input :filter_params, type: [Hash, ActionController::Parameters], default: {}, allow_nil: true

    output :items, type: Enumerable

    def call
      scope = Item.left_joins(:price).includes(:price).order(release_date_display: :desc)
      scope = ItemsFilter.apply(scope, filter_params)
      self.items = scope
    end
  end
end
