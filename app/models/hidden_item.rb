# frozen_string_literal: true

class HiddenItem < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :user_id, presence: true
  validates :item_id, presence: true

  validates :item_id, uniqueness: { scope: :user_id }
end
