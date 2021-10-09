# frozen_string_literal: true

class HiddenGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :user_id, presence: true
  validates :game_id, presence: true

  validates :game_id, uniqueness: { scope: :user_id }
end
