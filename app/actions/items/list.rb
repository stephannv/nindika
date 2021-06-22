# frozen_string_literal: true

module Items
  class List < Actor
    input :search_term, type: String, default: nil, allow_nil: true

    output :items, type: Enumerable

    def call
      scope = Item.left_joins(:price).includes(:price).order(release_date_display: :desc)
      scope = scope.search_by_title(search_term) if search_term.present?
      self.items = scope
    end
  end
end
