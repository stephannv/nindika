# frozen_string_literal: true

module Nintendo
  class PriceDataAdapter
    MAPPED_STATES = {
      'not_found' => PriceStates::UNAVAILABLE,
      'not_sale' => PriceStates::UNAVAILABLE,
      'sales_termination' => PriceStates::UNAVAILABLE,
      'onsale' => PriceStates::ON_SALE,
      'pre_order' => PriceStates::PRE_ORDER,
      'preorder' => PriceStates::PRE_ORDER,
      'unreleased' => PriceStates::UNRELEASED
    }.freeze

    ATTRIBUTES = %i[
      nsuid country_code base_price discount_price discount_started_at discount_ends_at state gold_points
    ].freeze

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def self.adapt(data)
      new(data).adapt
    end

    def adapt
      ATTRIBUTES.index_with { |attribute| send(attribute) }
    end

    def country_code
      'BR'
    end

    def nsuid
      data['id']
    end

    def base_price
      return if base_price_data.nil?

      @base_price ||= Monetize.parse(base_price_data.values_at('raw_value', 'currency'))
    end

    def discount_price
      return if discount_price_data.nil?

      @discount_price ||= Monetize.parse(discount_price_data.values_at('raw_value', 'currency'))
    end

    def discount_started_at
      return if discount_price_data.nil?

      Time.zone.parse(discount_price_data['start_datetime'])
    end

    def discount_ends_at
      return if discount_price_data.nil?

      Time.zone.parse(discount_price_data['end_datetime'])
    end

    def state
      status = data['sales_status']
      raise "#{status} NOT MAPPED PRICE STATE" unless MAPPED_STATES.key?(status)

      MAPPED_STATES[status]
    end

    def gold_points
      data.dig('price', 'gold_point', 'gift_gp')
    end

    private

    def base_price_data
      @base_price_data ||= data.dig('price', 'regular_price')
    end

    def discount_price_data
      @discount_price_data ||= data.dig('price', 'discount_price')
    end
  end
end
