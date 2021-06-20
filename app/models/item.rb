# frozen_string_literal: true

class Item < ApplicationRecord
  has_one :raw_item, dependent: :destroy
  has_one :price, dependent: :destroy

  has_many :notifications, as: :subject, dependent: :destroy

  has_many :price_history_items, through: :price, source: :history_items

  scope :with_nsuid, -> { where.not(nsuid: nil) }

  validates :title, presence: true
  validates :external_id, presence: true

  validates :external_id, uniqueness: true

  validates :title, length: { maximum: 1024 }
  validates :description, length: { maximum: 8192 }
  validates :slug, length: { maximum: 1024 }
  validates :website_url, length: { maximum: 1024 }
  validates :nsuid, length: { maximum: 32 }
  validates :external_id, length: { maximum: 256 }
  validates :boxart_url, length: { maximum: 1024 }
  validates :banner_url, length: { maximum: 1024 }
  validates :release_date_display, length: { maximum: 64 }
  validates :content_rating, length: { maximum: 64 }
end
