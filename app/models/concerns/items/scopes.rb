# frozen_string_literal: true

require "active_support/concern"

module Items
  module Scopes
    extend ActiveSupport::Concern

    included do
      scope :with_nsuid, -> { where.not(nsuid: nil) }
      scope :on_sale, -> { where(on_sale: true) }
      scope :new_release, -> { where(new_release: true) }
      scope :coming_soon, -> { where(coming_soon: true) }
      scope :pre_order, -> { where(pre_order: true) }
      scope :pending_scrap, -> { where(last_scraped_at: (..24.hours.ago)).or(where(last_scraped_at: nil)) }
      scope :with_prices, -> { joins(:price).includes(:price) }
      scope :including_prices, -> { left_joins(:price).includes(:price) }
    end
  end
end
