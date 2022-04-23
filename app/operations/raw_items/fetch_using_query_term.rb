# frozen_string_literal: true

module RawItems
  class FetchUsingQueryTerm < Actor
    input :client, type: NintendoAlgoliaClient, default: -> { NintendoAlgoliaClient.new }
    input :query_term, type: String

    output :raw_items_data, type: Array

    def call
      data = fetch_data
      self.raw_items_data = data.flatten.uniq { |d| d[:objectID] }.map { |d| d.except(:_highlightResult) }
    end

    private

    def fetch_data
      data = client.fetch(index: client.index_asc, query: query_term)
      data += client.fetch(index: client.index_desc, query: query_term) if data.size >= 500
      data
    end
  end
end
