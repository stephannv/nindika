class GameDocumentsSortOptions
  LIST = {
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
  }.freeze

  def self.get(option)
    sort_by = option&.to_sym
    LIST.key?(sort_by) ? LIST[sort_by] : 'all_time_visits:desc'
  end

  def self.list
    LIST
  end
end
