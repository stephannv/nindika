# frozen_string_literal: true

module Prices
  class Fetch < Actor
    input :client, type: NintendoPricesClient, default: -> { NintendoPricesClient.new }

    output :prices_data, type: Array

    def call
      prices_data = []

      Item.with_nsuid.find_in_batches(batch_size: 99) do |batch|
        prices_data += client.fetch(country: "BR", lang: "pt", nsuids: batch.pluck(:nsuid))
        sleep 1
      end

      self.prices_data = prices_data
    end
  end
end
