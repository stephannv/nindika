# frozen_string_literal: true

class PriceEntity < BaseEntity
  expose :base_price, using: MoneyEntity
  expose :discount_price, using: MoneyEntity, expose_nil: false
  expose :discounted_amount, using: MoneyEntity, expose_nil: false
  expose :discount_percentage, expose_nil: false

  expose :state do
    expose :code do |price|
      price.state
    end
    expose :text do |price|
      price.state_humanize
    end
  end

  with_options format_with: :iso_timestamp, expose_nil: false do
    expose :discount_started_at
    expose :discount_ends_at
  end
end
