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
    before { freeze_time }

    it "updates last scraped at with current time" do
      item = create(:item)
      scraped_data = {
        release_date: "2022-01-01T00:00:00.000Z",
        languages: [
          "American English", "Brazilian Portuguese", "British English", "Canadian French", "Dutch", "French",
          "German", "Italian", "Japanese", "Korean", "Latin American Spanish", "Portuguese", "Russian",
          "Simplified Chinese", "Spanish", "Traditional Chinese"
        ],
        bg_color: "000000",
        headline: "Some text",
        screenshot_urls: %w[url_a url_b],
        video_urls: ["url_c"],
        rom_size: "205912059",
        release_date_display: "2022"
      }
      allow(Nintendo::ItemPageScraper).to receive(:scrap).with(item.website_url).and_return(scraped_data)
      described_class.call(item: item)

      expect(item.reload.attributes).to include(
        "release_date" => Date.parse("2022-01-01"),
        "languages" => [
          "Inglês Americano", "Português Brasileiro", "Inglês Britânico", "Francês Canadense", "Holandês", "Francês",
          "Alemão", "Italiano", "Japonês", "Coreano", "Espanhol Latino", "Português", "Russo", "Chinês Simplificado",
          "Espanhol", "Chinês Tradicional"
        ],
        "bg_color" => "000000",
        "headline" => "Some text",
        "screenshot_urls" => %w[url_a url_b],
        "video_urls" => ["url_c"],
        "rom_size" => 205_912_059,
        "release_date_display" => "2022"
      )
    end

    it "creates item relationships" do
      item = create(:item)
      parents = create_list(:item, 2)
      scraped_data = { parent_nsuids: parents.map(&:nsuid) }
      allow(Nintendo::ItemPageScraper).to receive(:scrap).with(item.website_url).and_return(scraped_data)
      described_class.call(item: item)
      expect(item.parents).to match(parents)
    end
  end
end
