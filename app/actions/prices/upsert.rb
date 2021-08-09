# frozen_string_literal: true

module Prices
  class Upsert < Actor
    input :prices_data, type: Array

    def call
      prices_data.each do |price_data|
        import_price(price_data)
      rescue StandardError => e
        raise e if Rails.env.development?

        Sentry.capture_exception(e, extra: price_data)
      end
    end

    private

    def import_price(price_data)
      data = ::NintendoPriceDataAdapter.adapt(price_data)
      return if data[:base_price].blank?

      price = upsert_price(data)
      CreateHistoryItem.result(price: price)
      CreateNotification.result(price: price) if price.saved_changes?
    end

    def upsert_price(data)
      price = Price.find_or_initialize_by(nsuid: data[:nsuid])
      price.item ||= Item.find_by(nsuid: data[:nsuid])
      price.assign_attributes(data)
      price.save!
      price.item.update!(current_price: price.current_price)
      price
    end
  end
end
