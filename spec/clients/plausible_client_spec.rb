# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlausibleClient, type: :clients do
  describe "#stats_grouped_by_page" do
    it "requests /stats/breakdown grouping by page and filtering by period" do
      api_url = "https://some_plausible.api"
      api_key = "some_api_key"
      api_site_id = "some_site_id"

      allow(Rails.application.credentials).to receive(:plausible_api_url).and_return(api_url)
      allow(Rails.application.credentials).to receive(:plausible_api_key).and_return(api_key)
      allow(Rails.application.credentials).to receive(:plausible_api_site_id).and_return(api_site_id)

      client = described_class.new
      period = Date.parse("2020-01-01")..Date.parse("2020-04-25")
      page = 4
      limit = 200
      fake_result = [Faker::Types.rb_hash(number: 4).stringify_keys, Faker::Types.rb_hash(number: 4).stringify_keys]
      query = {
        property: "event:page",
        period: "custom",
        date: "2020-01-01,2020-04-25",
        page: page,
        limit: limit,
        site_id: api_site_id
      }

      stub_request(:get, "#{api_url}/stats/breakdown")
        .with(query: query, headers: { "Authorization" => "Bearer #{api_key}" })
        .to_return(body: { "results" => fake_result }.to_json, headers: { "Content-Type" => "application/json" })

      expect(client.stats_grouped_by_page(period: period, page: page, limit: limit)).to eq fake_result
    end
  end
end
