# frozen_string_literal: true

class Price < ApplicationRecord
  has_enumeration_for :state, with: PriceStates, create_helpers: true, required: true, create_scopes: true

  belongs_to :item

  monetize :regular_amount_cents, numericality: { greater_than_or_equal_to: 0 }
  monetize :discount_amount_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }

  validates :item_id, presence: true
  validates :nsuid, presence: true

  validates :item_id, uniqueness: true
  validates :nsuid, uniqueness: true

  validates :gold_points, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true
  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, only_integer: true }, allow_nil: true
end
