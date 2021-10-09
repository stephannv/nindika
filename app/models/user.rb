# frozen_string_literal: true

class User < ApplicationRecord
  has_many :wishlist_games, dependent: :destroy
  has_many :hidden_games, dependent: :destroy

  has_many :wishlist, through: :wishlist_games, source: :game
  has_many :hidden_list, through: :hidden_games, source: :game

  validates :provider, presence: true
  validates :uid, presence: true

  validates :uid, uniqueness: { scope: :provider }
end
