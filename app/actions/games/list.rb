# frozen_string_literal: true

module Games
  class List < Actor
    input :sort_by, type: String, default: nil, allow_nil: true
    input :after, type: String, default: nil, allow_nil: true
    input :per_page, type: Integer, default: 20

    output :games, type: Enumerable
    output :total, type: Integer

    def call
      scope = build_scope
      self.total = scope.count
      self.games = sort_and_paginate(scope)
    end

    private

    def build_scope
      Game.left_joins(:price).includes(:price)
    end

    def sort_and_paginate(scope)
      Games::KeysetPaginator.sort_and_paginate(
        relation: scope,
        sort_by: sort_by,
        after: after,
        per_page: per_page
      )
    end
  end
end
