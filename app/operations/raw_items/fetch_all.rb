# frozen_string_literal: true

module RawItems
  class FetchAll < Actor
    input :client, type: NintendoAlgoliaClient, default: -> { NintendoAlgoliaClient.new }

    output :raw_items_data, type: Array

    def call
      data = query_terms.map do |term|
        result = FetchUsingQueryTerm.result(client: client, query_term: term)
        result.raw_items_data
      end

      self.raw_items_data = data.flatten.uniq { |d| d[:objectID] }.map { |d| d.except(:_highlightResult) }
    end

    private

    def query_terms
      ("a".."z").to_a + ("0".."9").to_a
    end
  end
end
