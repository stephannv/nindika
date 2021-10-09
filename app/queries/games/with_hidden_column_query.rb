# frozen_string_literal: true

module Games
  class WithHiddenColumnQuery
    attr_reader :relation, :user_id, :include_hidden, :only_hidden

    def initialize(user_id:, relation: Game, include_hidden: false, only_hidden: false)
      @relation = relation
      @user_id = user_id
      @include_hidden = include_hidden
      @only_hidden = only_hidden
    end

    def self.call(...)
      new(...).call
    end

    def call
      if include_hidden || only_hidden
        with_hidden_column_relation
      else
        with_hidden_column_relation.where(hidden_games: { id: nil })
      end
    end

    def with_hidden_column_relation
      relation
        .select('games.*', 'hidden_games.id IS NOT NULL AS hidden')
        .joins(join_with_user_hidden_list)
    end

    def join_with_user_hidden_list
      <<-SQL.squish
        #{join_clause} JOIN hidden_games
        ON hidden_games.game_id = games.id and hidden_games.user_id = '#{user_id}'
      SQL
    end

    def join_clause
      only_hidden ? 'INNER' : 'LEFT'
    end
  end
end
