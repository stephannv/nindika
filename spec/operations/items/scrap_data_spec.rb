# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::ScrapData, type: :operations do
  include ActiveSupport::Testing::TimeHelpers

  describe "Inputs" do
    subject { described_class.inputs }

    it { is_expected.to include(item: { type: Item }) }
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe "#call" do
    subject(:result) { described_class.result(item: item) }

    let(:item) { create(:item) }
    let(:languages) { %w[Inglês Português Japonês] }
    let(:size) { "2.12 GB" }
    let(:screenshot_urls) { Faker::Lorem.words }

    before do
      allow(NintendoGamePageScraper).to receive(:scrap)
        .with(item.website_url)
        .and_return(languages: languages, size: size, screenshot_urls: screenshot_urls)
    end

    it "updates language codes with scraped languages" do
      result

      expect(item.reload.languages).to eq %w[EN PT JA]
    end

    it "updates bytesize with scraped size" do
      result

      expect(item.reload.bytesize).to eq 2_120_000_000
    end

    it "updates screenshot_urls with scraped screenshot urls" do
      result

      expect(item.reload.screenshot_urls).to eq screenshot_urls
    end

    it "updates last scraped at with current time" do
      travel_to 1.day.ago
      result
      expect(item.reload.last_scraped_at).to eq Time.zone.now
      travel_back
    end
  end
end
