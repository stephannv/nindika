# frozen_string_literal: true

class Price < ApplicationRecord
  has_enumeration_for :state, with: PriceStates, create_helpers: true, required: true, create_scopes: true

  belongs_to :item

  has_many :history_items, class_name: "PriceHistoryItem", dependent: :destroy

  monetize :base_price_cents, numericality: { greater_than_or_equal_to: 0 }
  monetize :discount_price_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  monetize :discounted_amount_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }

  validates :item_id, presence: true
  validates :nsuid, presence: true

  validates :item_id, uniqueness: true
  validates :nsuid, uniqueness: true

  validates :gold_points, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true
  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true

  def current_price
    discount_price || base_price
  end

  def saved_change_to_current_price?
    saved_change_to_base_price_cents? || saved_change_to_discount_price_cents?
  end

  def discount?
    discount_price.present?
  end

  def eshop_url
    "https://ec.nintendo.com/title_purchase_confirm?title=#{nsuid}"
  end
end
