# frozen_string_literal: true

module Items
  class List < Actor
    output :items, type: Enumerable

    def call
      self.items = Item
        .left_joins(:price)
        .includes(:price)
        .order(release_date_display: :desc)
    end
  end
end
