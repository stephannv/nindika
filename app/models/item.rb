# frozen_string_literal: true

class Item < ApplicationRecord
  include FriendlyId
  include PgSearch::Model
  include Items::Scopes

  has_one :raw_item, dependent: :destroy
  has_one :price, dependent: :destroy

  has_many :parent_relationships,
    class_name: "ItemRelationship",
    foreign_key: :parent_id,
    dependent: :destroy,
    inverse_of: :parent
  has_many :child_relationships,
    class_name: "ItemRelationship",
    foreign_key: :child_id,
    dependent: :destroy,
    inverse_of: :child
  has_many :events, class_name: "ItemEvent", dependent: :destroy

  has_many :children, through: :parent_relationships, class_name: "Item", source: :child
  has_many :parents, through: :child_relationships, class_name: "Item", source: :parent
  has_many :price_history_items, through: :price, source: :history_items

  enum :item_type, game: 0, game_bundle: 1, dlc: 2, dlc_bundle: 3

  friendly_id :title, use: :history

  monetize :current_price_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }

  pg_search_scope :search_by_title, against: :title, using: { tsearch: { dictionary: "english" } }, ignoring: :accents

  validates :item_type, presence: true
  validates :title, presence: true
  validates :external_id, presence: true

  validates :external_id, uniqueness: true

  validates :title, length: { maximum: 1024 }
  validates :description, length: { maximum: 8192 }
  validates :nsuid, length: { maximum: 32 }
  validates :external_id, length: { maximum: 256 }
  validates :release_date_display, length: { maximum: 64 }

  def to_param
    slug
  end

  def small_banner_url
    banner_url&.gsub("w_720", "w_480")
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
