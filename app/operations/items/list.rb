# frozen_string_literal: true

module Items
  class List < Actor
    input :filters_form, type: GameFiltersForm, default: -> { GameFiltersForm.new }
    input :sort_param, type: String, default: nil, allow_nil: true

    output :items, type: Enumerable

    def call
      self.items = build_scope
    end

    private

    def build_scope
      scope = Item.where(item_type: %i[game game_bundle]).including_prices
      scope = ItemsFilter.apply(relation: scope, filters_form: filters_form)
      ItemsSorter.apply(relation: scope, param: sort_param)
    end
  end
end
