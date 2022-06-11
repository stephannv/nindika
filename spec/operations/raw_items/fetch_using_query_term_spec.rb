# frozen_string_literal: true

require "rails_helper"

RSpec.describe RawItems::FetchUsingQueryTerm, type: :action do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(query_term: { type: String }) }

    it "injects nintendo algolia client dependency" do
      expect(inputs[:client][:default].call).to be_a(NintendoAlgoliaClient)
    end
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to include(raw_items_data: { type: Array }) }
  end

  describe "#call" do
    subject(:result) { described_class.result(client: client, query_term: "a") }

    let(:client) { NintendoAlgoliaClient.new }
    let(:items_a) { [{ objectID: "1", _highlightResult: "foo" }, { objectID: "2", _highlightResult: "foo" }] }
    let(:items_b) { [{ objectID: "2", _highlightResult: "foo" }, { objectID: "3", _highlightResult: "foo" }] }

    before do
      allow(client).to receive(:fetch)
        .with(index: client.index_asc, query: "a")
        .and_return(items_a)
      allow(client).to receive(:fetch)
        .with(index: client.index_desc, query: "a")
        .and_return(items_b)
    end

    context "when asc index returns less than 500 items" do
      it "returns gotten items using asc index" do
        expect(result.raw_items_data).to eq [{ objectID: "1" }, { objectID: "2" }]
      end
    end

    context "when asc index return more than 500 items" do
      before do
        allow(items_a).to receive(:size).and_return(600)
      end

      it "returns gotten items using asc and desc index" do
        expect(result.raw_items_data).to eq [{ objectID: "1" }, { objectID: "2" }, { objectID: "3" }]
      end
    end
  end
end
