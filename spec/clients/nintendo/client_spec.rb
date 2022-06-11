# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nintendo::Client, type: :client do
  describe "#list_items" do
    it "makes requests to nintendo endpoint and returns response" do
      client = described_class.new(app_id: "MY-APP-ID", app_key: "MY-APP-KEY")
      requests = [{ "request_a" => "test" }, { "request_b" => "test" }]
      fake_response = { "results" => %w[result_a result_b] }

      stub_request(:post, "https://my-app-id-dsn.algolia.net/1/indexes/*/queries")
        .with(
          body: { requests: requests }.to_json,
          headers: { "x-algolia-application-id" => "MY-APP-ID", "x-algolia-api-key" => "MY-APP-KEY" }
        )
        .to_return(body: fake_response.to_json)

      result = client.list_items(requests: requests)

      expect(result).to eq fake_response
    end
  end

  describe "#list_items_in_batches" do
    it "makes requests in batches and yields each response" do
      client = described_class.new(app_id: "MY-APP-ID", app_key: "MY-APP-KEY")

      requests = %w[req_1 req_2 req_3 req_4 req_5 req_6]
      response_a = { results: "a" }
      response_b = { results: "b" }
      response_c = { results: "c" }

      allow(client).to receive(:list_items).with(requests: %w[req_1 req_2]).and_return(response_a)
      allow(client).to receive(:list_items).with(requests: %w[req_3 req_4]).and_return(response_b)
      allow(client).to receive(:list_items).with(requests: %w[req_5 req_6]).and_return(response_c)

      expect do |b|
        client.list_items_in_batches(requests: requests, batch_size: 2, &b)
      end.to yield_successive_args(response_a, response_b, response_c)
    end
  end
end
