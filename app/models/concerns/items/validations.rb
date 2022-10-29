# frozen_string_literal: true

require "active_support/concern"

module Items
  module Validations
    extend ActiveSupport::Concern

    included do
      validates :item_type, presence: true
      validates :title, presence: true
      validates :external_id, presence: true

      validates :external_id, uniqueness: true

      validates :title, length: { maximum: 1024 }
      validates :description, length: { maximum: 8192 }
      validates :nsuid, length: { maximum: 32 }
      validates :external_id, length: { maximum: 256 }
      validates :release_date_display, length: { maximum: 64 }
    end
  end
end
