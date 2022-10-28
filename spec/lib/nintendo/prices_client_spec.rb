# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nintendo::PricesClient, type: :lib do
  describe "Configurations" do
    it "has default base_uri" do
      expect(described_class.base_uri).to eq "https://ec.nintendo.com/api"
    end
  end

  describe "#fetch" do
    it "requests given nsuids prices from nintendo servers" do
      country = "XX"
      lang = "YY"
      nsuids = %w[123 456 789]
      expected_querystring = "ns_uids=123&ns_uids=456&ns_uids=789"
      response = Faker::Types.rb_hash(number: 4).stringify_keys

      stub_request(:get, "#{described_class.base_uri}/#{country}/#{lang}/guest_prices?#{expected_querystring}")
        .to_return(body: response.to_json, headers: { "Content-Type" => "application/json" })

      result = described_class.new.fetch(country: country, lang: lang, nsuids: nsuids)

      expect(result).to eq response
    end

    context "when given nsuids count is greater than 99" do
      it "raises error" do
        nsuids = (1..100).to_a

        expect do
          described_class.new.fetch(country: "XX", lang: "YY", nsuids: nsuids)
        end.to raise_error("NSUIDS are limited to 99 per request")
      end
    end
  end
end
