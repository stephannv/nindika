# frozen_string_literal: true

module Prices
  class Fetch < Actor
    input :client, type: NintendoPricesClient, default: -> { NintendoPricesClient.new }

    output :prices_data, type: Array

    def call
      self.prices_data = []

      Item.with_nsuid.find_in_batches(batch_size: 99) do |batch|
        nsuids = batch.pluck(:nsuid)
        response = fetch_data(nsuids)

        if response.is_a?(Array)
          prices_data.concat response
        else
          prices_data.concat fetch_data_individually(nsuids)
        end
      end
    end

    private

    def fetch_data(nsuids)
      client.fetch(country: "BR", lang: "pt", nsuids: nsuids)
    end

    # Some NSUID returns a html page titled "The page you requested is not available. - Nintendo"
    # so we need to iterated each nsuid from batch to get price skipping nsuid with error
    def fetch_data_individually(nsuids)
      data = nsuids.map do |nsuid|
        response = fetch_data([nsuid])

        if response.is_a?(Array)
          response
        else
          Sentry.capture_message("NSUID WITH PRICE ERROR", level: :fatal, extra: { nsuid: nsuid })
          nil
        end
      end

      data.compact
    end
  end
end
