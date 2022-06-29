# frozen_string_literal: true

module Nintendo
  class PricesClient
    include HTTParty

    base_uri "https://ec.nintendo.com/api"

    def fetch(country:, lang:, nsuids:)
      raise "NSUIDS are limited to 99 per request" if nsuids.to_a.size > 99

      response = self.class.get("/#{country}/#{lang}/guest_prices", query: build_nsuids_querystring(nsuids))
      response.parsed_response
    end

    private

    def build_nsuids_querystring(nsuids)
      nsuids.map { |nsuid| "ns_uids=#{nsuid}" }.join("&")
    end
  end
end
