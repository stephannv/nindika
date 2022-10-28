# frozen_string_literal: true

module Nintendo
  class PriceDataAdapter
    ATTRIBUTES = %i[
      nsuid base_price discount_price discount_started_at discount_ends_at
      discount_percentage discounted_amount state gold_points
    ].freeze

    def initialize(data)
      @data = data
    end

    def self.adapt(data)
      new(data).adapt
    end

    def adapt
      ATTRIBUTES.index_with { |attribute| send(attribute) }
    end

    def nsuid
      @data["id"]
    end

    def base_price
      return if base_price_data.nil?

      @base_price ||= Monetize.parse(base_price_data.values_at("raw_value", "currency"))
    end

    def discount_price
      return if discount_price_data.nil?

      @discount_price ||= Monetize.parse(discount_price_data.values_at("raw_value", "currency"))
    end

    def discount_started_at
      return if discount_price_data.nil?

      Time.zone.parse(discount_price_data["start_datetime"])
    end

    def discount_ends_at
      return if discount_price_data.nil?

      Time.zone.parse(discount_price_data["end_datetime"])
    end

    def discount_percentage
      return if discount_price_data.nil?

      ((1 - (discount_price.cents.to_f / base_price.cents)) * 100).round
    end

    def discounted_amount
      return if discount_price_data.nil?

      [base_price - discount_price, 0].max
    end

    # rubocop:disable Metrics/MethodLength
    def state
      case @data["sales_status"]
      when "not_found", "not_sale", "sales_termination"
        PriceStates::UNAVAILABLE
      when "onsale"
        PriceStates::ON_SALE
      when "pre_order", "preorder"
        PriceStates::PRE_ORDER
      when "unreleased"
        PriceStates::UNRELEASED
      else
        raise "#{@data['sales_status']} NOT MAPPED PRICE STATE"
      end
    end
    # rubocop:enable Metrics/MethodLength

    def gold_points
      @data.dig("price", "gold_point", "gift_gp")
    end

    private

    def base_price_data
      @base_price_data ||= @data.dig("price", "regular_price")
    end

    def discount_price_data
      @discount_price_data ||= @data.dig("price", "discount_price")
    end
  end
end
