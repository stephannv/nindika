# frozen_string_literal: true

module Items
  class WithoutHiddenQuery
    attr_reader :relation, :user_id

    def self.call(user_id:, relation: Item)
      new(relation: relation, user_id: user_id).call
    end

    def initialize(user_id:, relation: Item)
      @relation = relation
      @user_id = user_id
    end

    def call
      left_join_with_user_hidden_list = <<-SQL.squish
        LEFT JOIN hidden_items
        ON hidden_items.item_id = items.id and hidden_items.user_id = '#{user_id}'
      SQL

      relation
        .joins(left_join_with_user_hidden_list)
        .where(hidden_items: { id: nil })
    end
  end
end
