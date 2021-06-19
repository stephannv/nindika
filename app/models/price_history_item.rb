# frozen_string_literal: true

class PriceHistoryItem < ApplicationRecord
  belongs_to :price

  monetize :amount_cents, numericality: { greater_than_or_equal_to: 0 }

  validates :price_id, presence: true
  validates :reference_date, presence: true

  validates :reference_date, uniqueness: { scope: :price_id }
end
