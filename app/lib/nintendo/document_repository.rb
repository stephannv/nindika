# frozen_string_literal: true

module Nintendo
  class DocumentRepository < Actor
    attr_reader :client

    def initialize(client: Nintendo::AlgoliaClient.new)
      @client = client
    end

    def search(term)
      data = client.fetch(index: client.index_asc, query: term)
      data += client.fetch(index: client.index_desc, query: term) if data.size >= 500
      data
        .flatten
        .uniq { |d| d[:objectID] }
        .map { |d| d.except(:_highlightResult) }
    end
  end
end
