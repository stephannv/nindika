# frozen_string_literal: true

class WishlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :item, counter_cache: :wishlists_count

  validates :user_id, presence: true
  validates :item_id, presence: true

  validates :item_id, uniqueness: { scope: :user_id }
end
