# frozen_string_literal: true

class ItemsSorter
  OPTIONS = {
    all_time_visits_desc: {
      text: I18n.t('games.sort_options.all_time_visits_desc'),
      query: 'items.all_time_visits DESC NULLS LAST'
    },
    last_week_visits_desc: {
      text: I18n.t('games.sort_options.last_week_visits_desc'),
      query: 'items.last_week_visits DESC NULLS LAST'
    },
    title_asc: {
      text: I18n.t('games.sort_options.title_asc'),
      query: 'items.title ASC'
    },
    release_date_desc: {
      text: I18n.t('games.sort_options.release_date_desc'),
      query: 'items.release_date DESC'
    },
    release_date_asc: {
      text: I18n.t('games.sort_options.release_date_asc'),
      query: 'items.release_date ASC'
    },
    price_asc: {
      text: I18n.t('games.sort_options.price_asc'),
      query: 'coalesce(prices.discount_price_cents, prices.base_price_cents) ASC NULLS LAST',
      left_joins: :price
    },
    price_desc: {
      text: I18n.t('games.sort_options.price_desc'),
      query: 'coalesce(prices.discount_price_cents, prices.base_price_cents) DESC NULLS LAST',
      left_joins: :price
    },
    discounted_amount_desc: {
      text: I18n.t('games.sort_options.discounted_amount_desc'),
      query: 'prices.discounted_amount_cents DESC NULLS LAST',
      left_joins: :price
    },
    discounted_amount_desc: {
      text: I18n.t('games.sort_options.discounted_amount_desc'),
      query: 'prices.discounted_amount_cents DESC NULLS LAST',
      left_joins: :price
    },
    discount_percentage_desc: {
      text: I18n.t('games.sort_options.discount_percentage_desc'),
      query: 'prices.discount_percentage DESC NULLS LAST',
      left_joins: :price
    },
    discount_start_date_desc: {
      text: I18n.t('games.sort_options.discount_start_date_desc'),
      query: 'prices.discount_started_at DESC NULLS LAST',
      left_joins: :price
    },
    discount_end_date_asc: {
      text: I18n.t('games.sort_options.discount_end_date_asc'),
      query: 'prices.discount_ends_at ASC NULLS LAST',
      left_joins: :price
    }
  }.freeze

  attr_accessor :relation, :param

  def initialize(relation: Item, param: nil)
    @relation = relation
    @param = param.try(:to_sym)
  end

  def self.apply(...)
    new(...).apply
  end

  def apply
    sort_key = OPTIONS.key?(param) ? param : :all_time_visits_desc
    option = OPTIONS[sort_key]

    self.relation = relation
      .left_joins(option[:left_joins])
      .order(Arel.sql(option[:query]))

    relation.order('items.id ASC')
  end
end
