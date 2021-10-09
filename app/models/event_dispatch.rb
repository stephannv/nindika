# frozen_string_literal: true

class EventDispatch < ApplicationRecord
  has_enumeration_for :provider,
    with: EventDispatchProviders,
    create_helpers: true,
    required: true,
    create_scopes: true

  belongs_to :game_event

  scope :pending, -> { where(sent_at: nil) }

  validates :game_event_id, presence: true

  validates :provider, uniqueness: { scope: :game_event_id }
end
