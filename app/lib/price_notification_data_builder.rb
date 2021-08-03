# frozen_string_literal: true

class PriceNotificationDataBuilder
  attr_reader :price, :item

  def initialize(price:)
    @price = price
    @item = price.item
  end

  def self.build(price:)
    new(price: price).build
  end

  def build
    type = notification_type
    return nil if type.blank?

    {
      notification_type: type,
      title: item.title,
      body: NotificationTypes.t(type),
      url: Rails.application.routes.url_helpers.game_url(item.slug),
      image_url: item.boxart_url,
      fields: fields
    }
  end

  private

  def notification_type
    if price_uncovered?
      NotificationTypes::PRICE_UNCOVERED
    elsif discounted_price?
      NotificationTypes::DISCOUNTED_PRICE
    elsif price_readjustment?
      NotificationTypes::PRICE_READJUSTMENT
    elsif pre_order_discount?
      NotificationTypes::PRE_ORDER_DISCOUNT
    end
  end

  def fields
    base_fields + discount_fields + readjustment_fields
  end

  def base_fields
    [
      { name: :current_price, value: price.current_price.formatted },
      { name: :website_url, value: item.website_url }
    ]
  end

  def discount_fields
    return [] unless discount?

    [
      { name: :original_price, value: price.base_price.formatted },
      { name: :discount_percentage, value: "#{price.discount_percentage}%" },
      { name: :started_at, value: price.discount_started_at },
      { name: :ends_at, value: price.discount_ends_at }
    ]
  end

  def readjustment_fields
    return [] unless price_readjustment?

    old_amount = Money.new(
      price.saved_change_to_base_price_cents.first.to_i,
      price.current_price.currency.iso_code
    )
    [{ name: :old_price, value: old_amount.formatted }]
  end

  def price_uncovered?
    new_price? && !discount_price_was_updated?
  end

  def discounted_price?
    !new_price? && discount? && discount_price_was_updated?
  end

  def price_readjustment?
    !new_price? && !discount_price_was_updated? && base_price_was_updated?
  end

  def pre_order_discount?
    new_price? && discount? && discount_price_was_updated?
  end

  def new_price?
    price.saved_change_to_id?
  end

  def discount_price_was_updated?
    price.saved_change_to_discount_price_cents?
  end

  def base_price_was_updated?
    price.saved_change_to_base_price_cents?
  end

  def discount?
    price.discount_price.present?
  end
end
