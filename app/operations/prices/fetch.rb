# frozen_string_literal: true

module Prices
  class Fetch < Actor
    input :client, type: Nintendo::PricesClient, default: -> { Nintendo::PricesClient.new }

    output :prices_data, type: Array

    def call
      prices_data = []

      Item.with_nsuid.find_in_batches(batch_size: 99) do |batch|
        nsuids = remove_invalid_nsuids(batch.pluck(:nsuid))
        prices_data += client.fetch(country: "BR", lang: "pt", nsuids: nsuids)
        sleep 1
      end

      self.prices_data = prices_data
    end

    private

    # Some items has invalid nsuids. eg.: `bayonetta3` and 'KDB`.
    # This code rejects nsuids using letters and keeps numbers only nsuids.
    def remove_invalid_nsuids(nsuids)
      nsuids.reject { |nsuid| nsuid.to_i.zero? }
    end
  end
end
