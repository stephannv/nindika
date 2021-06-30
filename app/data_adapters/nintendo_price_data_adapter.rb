# frozen_string_literal: true

class NintendoPriceDataAdapter
  def initialize(data)
    @data = data
  end

  def self.adapt(data)
    new(data).adapt
  end

  def adapt
    {
      nsuid: nsuid,
      regular_amount: regular_amount,
      discount_amount: discount_amount,
      discount_started_at: discount_started_at,
      discount_ends_at: discount_ends_at,
      discount_percentage: discount_percentage,
      discounted_amount: discounted_amount,
      state: state,
      gold_points: gold_points
    }
  end

  def nsuid
    @data['id']
  end

  def regular_amount
    return if regular_amount_data.nil?

    @regular_amount ||= Monetize.parse(regular_amount_data.values_at('raw_value', 'currency'))
  end

  def discount_amount
    return if discount_amount_data.nil?

    @discount_amount ||= Monetize.parse(discount_amount_data.values_at('raw_value', 'currency'))
  end

  def discount_started_at
    return if discount_amount_data.nil?

    Time.zone.parse(discount_amount_data['start_datetime'])
  end

  def discount_ends_at
    return if discount_amount_data.nil?

    Time.zone.parse(discount_amount_data['end_datetime'])
  end

  def discount_percentage
    return if discount_amount_data.nil?

    ((1 - (discount_amount.cents.to_f / regular_amount.cents)) * 100).round
  end

  def discounted_amount
    return if discount_amount_data.nil?

    [regular_amount - discount_amount, 0].max
  end

  # rubocop:disable Metrics/MethodLength
  def state
    case @data['sales_status']
    when 'not_found', 'not_sale', 'sales_termination'
      PriceStates::UNAVAILABLE
    when 'onsale'
      PriceStates::ON_SALE
    when 'pre_order', 'preorder'
      PriceStates::PRE_ORDER
    when 'unreleased'
      PriceStates::UNRELEASED
    else
      raise "#{@data['sales_status']} NOT MAPPED PRICE STATE"
    end
  end
  # rubocop:enable Metrics/MethodLength

  def gold_points
    @data.dig('price', 'gold_point', 'gift_gp')
  end

  private

  def regular_amount_data
    @regular_amount_data ||= @data.dig('price', 'regular_price')
  end

  def discount_amount_data
    @discount_amount_data ||= @data.dig('price', 'discount_price')
  end
end
