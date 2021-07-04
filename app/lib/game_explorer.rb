class GameExplorer
  attr_reader :client, :search_term, :filters, :page, :sort_by

  DEFAULT_PARAMS = {
    query_by: 'title',
    prefix: false,
    num_typos: 1,
    facet_by:'genres,companies,franchises',
    per_page: 20
  }.freeze

  SORT_OPTIONS = {
    popularity: 'all_time_visits:desc',
    hot: 'last_week_visits:desc',
    title: 'title_order:asc',
    new: 'release_date_timestamp:desc',
    old: 'release_date_timestamp:asc',
    cheaper: 'current_amount_cents:asc',
    expensive: 'current_amount_cents:desc',
    discounted_amount: 'discounted_amount_cents:desc',
    discount_percentage: 'discount_percentage:desc',
    new_discounts: 'discount_started_at_timestamp:desc',
    expiring_discounts: 'discount_ends_at_timestamp:asc'
  }

  def initialize(client: Typesense::Client.new(TypesenseConnection), filters: {}, page: nil, sort_by: nil)
    @client = client
    @filters = filters
    @search_term = filters[:title] || '*'
    @page = page.to_i == 0 ? 1 : page
    @sort_by = SORT_OPTIONS.key?(sort_by&.to_sym) ? SORT_OPTIONS[sort_by.to_sym] : 'all_time_visits:desc'
  end

  def self.search(...)
    new(...).search
  end

  def search
    response = client.collections['games'].documents.search(params)

    OpenStruct.new(
      items: response['hits'].map { |data| transform_game(data) },
      total: response['found'],
      facets: response['facet_counts']
    )
  end

  private

  def params
    r = DEFAULT_PARAMS.merge(q: search_term, page: page, sort_by: sort_by)
    r = r.merge(filter_by: filter_by) if filter_by.present?
    r
  end

  def transform_game(data)
    JSON.parse(data.to_json, object_class: OpenStruct)
  end

  def filter_by
    array = []
    array << 'on_sale:true' if filters[:on_sale]
    array << 'new_release:true' if filters[:new_release]
    array << 'coming_soon:true' if filters[:coming_soon]
    array << 'pre_order:true' if filters[:pre_order]
    array.join(' AND ')
  end
end
