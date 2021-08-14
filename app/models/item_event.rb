# frozen_string_literal: true

class ItemEvent < ApplicationRecord
  belongs_to :item

  has_enumeration_for :event_type,
    with: ItemEventTypes,
    create_helpers: true,
    required: true,
    create_scopes: true

  validates :item_id, presence: true
  validates :title, presence: true
  validates :url, presence: true
end
