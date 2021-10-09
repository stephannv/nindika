# frozen_string_literal: true

class GameEvent < ApplicationRecord
  belongs_to :game

  has_many :dispatches, class_name: 'EventDispatch', dependent: :destroy

  has_enumeration_for :event_type,
    with: GameEventTypes,
    create_helpers: { polymorphic: true },
    required: true,
    create_scopes: true

  validates :game_id, presence: true
  validates :title, presence: true
  validates :url, presence: true
end
