# frozen_string_literal: true

module Games
  class KeysetPaginator
    def initialize(relation:, sort_by: nil, after: nil, per_page: 20)
      @relation = relation
      @sort_by = sort_by
      @per_page = per_page
      @after = after
      @option, @direction = sort_by.to_s.split(':')
    end

    def self.sort_and_paginate(...)
      new(...).sort_and_paginate
    end

    def sort_and_paginate
      seek_option = relation.seek_option(option, direction)
      space = relation.seek(seek_option)

      space = if after.present? && (game = Game.find_by(id: after))
        space.at(game).after
      else
        space.scope
      end

      space.limit(per_page)
    end

    private

    attr_accessor :relation, :sort_by, :after, :per_page, :option, :direction
  end
end
