# frozen_string_literal: true

class Item < ApplicationRecord
  include FriendlyId
  include PgSearch::Model
  include Items::Relations
  include Items::Scopes
  include Items::Validations

  attribute :wishlisted, :boolean, default: false # this attr will be filled using WithWishlistedColumnQuery

  has_enumeration_for :item_type, with: ItemTypes, create_helpers: true, required: true, create_scopes: true

  friendly_id :title, use: :history

  monetize :current_price_cents, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }

  pg_search_scope :search_by_title, against: :title, using: { tsearch: { dictionary: "english" } }, ignoring: :accents

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
