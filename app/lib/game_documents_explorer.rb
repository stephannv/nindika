class GameDocumentsExplorer
  attr_reader :client, :filters, :sort_by, :page

  DEFAULT_PARAMS = {
    query_by: 'title',
    prefix: false,
    num_typos: 1,
    facet_by:'genres,companies,franchises',
    per_page: 20
  }.freeze

  def initialize(client: Typesense::Client.new(TypesenseConnection), filters:, sort_by:, page:)
    @client = client
    @filters = filters
    @sort_by = GameDocumentsSortOptions.get(sort_by)
    @page = page
  end

  def self.search(...)
    new(...).search
  end

  def search
    response = client.collections['games'].documents.search(params)
    items = response['hits'].map { |data| transform_game(data) }

    OpenStruct.new(items: items, total: response['found'], facets: response['facet_counts'])
  end

  private

  def transform_game(data)
    JSON.parse(data.to_json, object_class: OpenStruct)
  end

end
