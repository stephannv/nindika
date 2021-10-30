# frozen_string_literal: true

class Game < ApplicationRecord
  include FriendlyId
  include PgSearch::Model
  include Games::KeysetPagination

  has_one :raw_item, dependent: :destroy
  has_one :price, dependent: :destroy

  has_many :events, class_name: 'GameEvent', dependent: :destroy
  has_many :wishlist_games, dependent: :destroy
  has_many :hidden_games, dependent: :destroy

  has_many :price_history_items, through: :price, source: :history_items

  friendly_id :title, use: :history

  monetize :current_price_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }

  pg_search_scope :search_by_title, against: :title, using: { tsearch: { dictionary: 'english' } }, ignoring: :accents

  scope :with_nsuid, -> { where.not(nsuid: nil) }
  scope :pending_scrap, -> { where(last_scraped_at: (..24.hours.ago)).or(where(last_scraped_at: nil)) }

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

  def medium_banner_url
    NintendoImageTransformer.medium(banner_url)
  end

  def release_date_text
    I18n.l(release_date_display.to_date)
  rescue Date::Error
    release_date_display
  end

  private

  def should_generate_new_friendly_id?
    title_changed? || super
  end
end
