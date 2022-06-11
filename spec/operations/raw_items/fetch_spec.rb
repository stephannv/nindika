# frozen_string_literal: true

require "rails_helper"

RSpec.describe RawItems::Fetch, type: :operation do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it "injects nintendo client dependency" do
      expect(inputs[:client][:default].call).to be_a(Nintendo::Client)
    end
  end

  describe "#call" do
    it "fetches data from nintendo and returns items distincting by ObjectID, ignoring createdAt and updatedAt" do
      client = Nintendo::Client.new

      response_a = {
        "results" => [
          { "hits" => [{ "objectID" => 1, "createdAt" => Time.zone.now, "updatedAt" => Time.zone.now }] },
          { "hits" => [{ "objectID" => 2, "createdAt" => Time.zone.now, "updatedAt" => Time.zone.now }] }
        ]
      }
      response_b = {
        "results" => [
          { "hits" => [{ "objectID" => 2, "createdAt" => Time.zone.now, "updatedAt" => Time.zone.now }] },
          { "hits" => [{ "objectID" => 3, "createdAt" => Time.zone.now, "updatedAt" => Time.zone.now }] }
        ]
      }
      response_c = {
        "results" => [
          { "hits" => [{ "objectID" => 3, "createdAt" => Time.zone.now, "updatedAt" => Time.zone.now }] },
          { "hits" => [{ "objectID" => 4, "createdAt" => Time.zone.now, "updatedAt" => Time.zone.now }] }
        ]
      }
      allow(client).to receive(:list_items_in_batches)
        .and_yield(response_a)
        .and_yield(response_b)
        .and_yield(response_c)

      result = described_class.result(client: client)

      expect(result.raw_items_data).to match [
        { "objectID" => 1 }, { "objectID" => 2 }, { "objectID" => 3 }, { "objectID" => 4 }
      ]
    end
  end
end
