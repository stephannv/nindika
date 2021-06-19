# frozen_string_literal: true

class RawItem < ApplicationRecord
  belongs_to :item, optional: true

  scope :pending, -> { where(imported: false) }

  validates :external_id, presence: true
  validates :checksum, presence: true

  validates :item_id, uniqueness: true, allow_nil: true
  validates :external_id, uniqueness: true

  validates :external_id, length: { maximum: 256 }
  validates :checksum, length: { maximum: 512 }
end
