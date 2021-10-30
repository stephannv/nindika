# frozen_string_literal: true

require 'active_support/concern'

module Games
  module KeysetPagination
    extend ActiveSupport::Concern

    SEEK_OPTIONS = {
      popularity: [:all_time_visits, :asc, { nulls: :last }].freeze,
      hot: [:last_week_visits, :asc, { nulls: :last }].freeze,
      title: %i[title asc].freeze,
      release_date: %i[release_date asc].freeze,
      price: [:current_price_cents, :asc, { nulls: :last }].freeze,
      discounted_amount: [
        :discounted_amount_cents, :asc, { nulls: :last, sql: 'prices.discounted_amount_cents' }
      ].freeze,
      discount_percentage: [:discount_percentage, :asc, { nulls: :last, sql: 'prices.discount_percentage' }].freeze,
      discount_start_date: [:discount_started_at, :asc, { nulls: :last, sql: 'prices.discount_started_at' }].freeze,
      discount_end_date: [:discount_ends_at, :asc, { nulls: :last, sql: 'prices.discount_ends_at' }].freeze
    }.freeze

    included do
      include OrderQuery

      # These delegates are needed due to keyset pagination
      delegate :discounted_amount_cents, :discount_percentage, :discount_started_at, :discount_ends_at, to: :price

      def self.seek_option(attribute, direction)
        option = SEEK_OPTIONS[attribute.to_s.to_sym].dup || SEEK_OPTIONS[:popularity].dup
        option[option.index(:asc)] = :desc unless direction.to_s == 'asc'
        option
      end
    end
  end
end
