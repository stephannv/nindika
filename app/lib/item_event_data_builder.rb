# frozen_string_literal: true

class ItemEventDataBuilder
  attr_reader :event_type, :item, :price

  ATTRIBUTES = {
    ItemEventTypes::GAME_ADDED => %i[release_date].freeze,
    ItemEventTypes::PRICE_ADDED => %i[current_price base_price discount_percentage discount_ends_at state].freeze,
    ItemEventTypes::DISCOUNT => %i[current_price base_price discount_percentage discount_ends_at].freeze,
    ItemEventTypes::PERMANENT_PRICE_CHANGE => %i[current_price old_price].freeze,
    ItemEventTypes::PRICE_STATE_CHANGE => %i[current_price].freeze
  }.freeze

  def initialize(event_type:, item:, price:)
    @event_type = event_type
    @item = item
    @price = price
  end

  def self.build(...)
    new(...).build
  end

  def build
    ATTRIBUTES[event_type].index_with { |attribute| send(attribute) }.compact
  end

  def release_date
    item.release_date_text
  end

  def current_price
    price.current_price.formatted
  end

  def base_price
    price.base_price.formatted if price.discount?
  end

  def discount_percentage
    "#{price.discount_percentage}%" if price.discount?
  end

  def discount_ends_at
    I18n.l(price.discount_ends_at, format: :shorter) if price.discount?
  end

  def state
    price.state_humanize
  end

  def old_price
    Money.new(
      price.saved_change_to_base_price_cents.first.to_i,
      price.current_price.currency.iso_code
    ).formatted
  end
end
