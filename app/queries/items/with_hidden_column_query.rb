# frozen_string_literal: true

module Items
  class WithHiddenColumnQuery
    attr_reader :relation, :user_id, :include_hidden, :only_hidden

    def initialize(user_id:, relation: Item, include_hidden: false, only_hidden: false)
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
        with_hidden_column_relation.where(hidden_items: { id: nil })
      end
    end

    def with_hidden_column_relation
      relation
        .select('items.*', 'hidden_items.id IS NOT NULL AS hidden')
        .joins(join_with_user_hidden_list)
    end

    def join_with_user_hidden_list
      <<-SQL.squish
        #{join_clause} JOIN hidden_items
        ON hidden_items.item_id = items.id and hidden_items.user_id = '#{user_id}'
      SQL
    end

    def join_clause
      only_hidden ? 'INNER' : 'LEFT'
    end
  end
end
