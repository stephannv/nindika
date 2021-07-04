class GameIndexSerializer
  include Alba::Resource

  SCHEMA = {
    name: 'games',
    default_sorting_field: 'all_time_visits',
    fields: [
      { name: 'id', type: 'string', facet: true },
      { name: 'title', type: 'string' },
      { name: 'title_order', type: 'int64' },
      { name: 'release_date_timestamp', type: 'int64' },
      { name: 'current_amount_cents', type: 'int32', optional: true },
      { name: 'discount_started_at_timestamp', type: 'int64', optional: true },
      { name: 'discount_ends_at_timestamp', type: 'int64', optional: true },
      { name: 'discount_percentage', type: 'int32', optional: true },
      { name: 'discounted_amount_cents', type: 'int32', optional: true },
      { name: 'all_time_visits', type: 'int32' },
      { name: 'last_week_visits', type: 'int32' },
      { name: 'companies', type: 'string[]', facet: true },
      { name: 'genres', type: 'string[]', facet: true },
      { name: 'franchises', type: 'string[]', facet: true },
      { name: 'on_sale', type: 'bool' },
      { name: 'new_release', type: 'bool' },
      { name: 'coming_soon', type: 'bool' },
      { name: 'pre_order', type: 'bool' }
    ]
  }.freeze

  ATTRIBUTES = %i[
    id title slug release_date_display website_url boxart_url banner_url medium_banner_url all_time_visits
    last_week_visits genres franchises on_sale new_release coming_soon pre_order companies
  ].freeze

  attributes *ATTRIBUTES

  attribute(:release_date_timestamp) { |item| item.release_date.to_datetime.to_i }
  attribute(:current_amount_cents) { |item| item.price&.current_amount&.cents }
  attribute(:current_amount_display) { |item| item.price&.current_amount&.formatted }
  attribute(:regular_amount_cents) { |item| item.price&.regular_amount_cents }
  attribute(:regular_amount_display) { |item| item.price&.regular_amount&.formatted }
  attribute(:discount_started_at_timestamp) { |item| item.price&.discount_started_at&.to_i }
  attribute(:discount_ends_at_timestamp) { |item| item.price&.discount_ends_at&.to_i }
  attribute(:discount_percentage) { |item| item.price&.discount_percentage }
  attribute(:discounted_amount_cents) { |item| item.price&.discounted_amount&.cents }
  attribute(:discounted_amount_cents) { |item| item.price&.discounted_amount&.cents }
end
