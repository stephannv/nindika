# frozen_string_literal: true

module Prices
  class Create < Actor
    input :prices_data, type: Array

    def call
      prices_data.each do |price_data|
        import_price(price_data)
      end
    end

    def import_price(price_data)
      data = ::NintendoPriceDataAdapter.adapt(price_data)
      return if data[:regular_amount].blank?

      price = Price.find_or_initialize_by(nsuid: data[:nsuid])
      price.item ||= Item.find_by(nsuid: data[:nsuid])
      price.assign_attributes(data)
      price.save!
      CreateHistoryItem.result(price: price)
    rescue StandardError => e
      raise e if Rails.env.development?

      Sentry.capture_exception(e, extra: price_data)
    end
  end
end
