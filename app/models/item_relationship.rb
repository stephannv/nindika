# frozen_string_literal: true

class ItemRelationship < ApplicationRecord
  belongs_to :parent, class_name: "Item"
  belongs_to :child, class_name: "Item"

  validates :parent_id, presence: true
  validates :child_id, presence: true

  validates :child_id, uniqueness: { scope: :parent_id }
end
