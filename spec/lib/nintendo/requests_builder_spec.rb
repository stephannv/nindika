# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nintendo::RequestsBuilder, type: :lib do
  describe ".build" do
    it "returns every needed request to retrieve nintendo data" do
      result = described_class.build
      # check spec/fixtures/filex/nintendo-client-requests.json
      expected_result = JSON.parse(file_fixture("nintendo-client-requests.json").read).map(&:symbolize_keys)
      expect(result).to eq expected_result
    end
  end
end
