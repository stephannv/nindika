# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: Devise.omniauth_providers

  has_many :wishlist_items, dependent: :destroy
  has_many :hidden_items, dependent: :destroy

  has_many :wishlist, through: :wishlist_items, source: :item
  has_many :hidden_list, through: :hidden_items, source: :item

  validates :provider, presence: true
  validates :uid, presence: true

  validates :uid, uniqueness: { scope: :provider }
end
