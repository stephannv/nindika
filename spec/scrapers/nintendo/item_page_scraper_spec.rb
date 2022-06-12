# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nintendo::ItemPageScraper, type: :scraper do
  describe "#scrap" do
    before do
      stub_request(:get, "https://game.page").to_return(body: file_fixture("pokemon-game-page.html"), status: 200)
    end

    it "scrapes release date" do
      data = described_class.scrap("https://game.page")

      expect(data[:release_date]).to eq "2022-11-18T00:00:00.000Z"
    end

    it "scrapes release date display" do
      data = described_class.scrap("https://game.page")

      expect(data[:release_date_display]).to eq "2022"
    end

    it "scrapes languages" do
      data = described_class.scrap("https://game.page")

      expect(data[:languages]).to eq [
        "American English", "French", "German", "Japanese", "Korean", "Simplified Chinese", "Spanish"
      ]
    end

    it "scrapes bg_color" do
      data = described_class.scrap("https://game.page")

      expect(data[:bg_color]).to eq "0a0508"
    end

    it "scrapes headline" do
      data = described_class.scrap("https://game.page")

      expect(data[:headline]).to eq "Embarque em um nova aventura Pokémon™ "
    end

    it "scrapes screnshoot_urls" do
      data = described_class.scrap("https://game.page")

      expect(data[:screenshot_urls]).to eq [
        "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_700/ncom/pt_BR/dlc/switch-dlc/pokemon-violet-dlc/rom-bundle/pokemon-scarlet-and-pokemon-violet-double-pack/screenshot01",
        "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_700/ncom/pt_BR/dlc/switch-dlc/pokemon-violet-dlc/rom-bundle/pokemon-scarlet-and-pokemon-violet-double-pack/screenshot02",
        "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_700/ncom/pt_BR/dlc/switch-dlc/pokemon-violet-dlc/rom-bundle/pokemon-scarlet-and-pokemon-violet-double-pack/screenshot03",
        "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_700/ncom/pt_BR/dlc/switch-dlc/pokemon-violet-dlc/rom-bundle/pokemon-scarlet-and-pokemon-violet-double-pack/screenshot04",
        "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_700/ncom/pt_BR/dlc/switch-dlc/pokemon-violet-dlc/rom-bundle/pokemon-scarlet-and-pokemon-violet-double-pack/screenshot05",
        "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_700/ncom/pt_BR/dlc/switch-dlc/pokemon-violet-dlc/rom-bundle/pokemon-scarlet-and-pokemon-violet-double-pack/screenshot06"
      ]
    end

    it "scrapes video_urls" do
      data = described_class.scrap("https://game.page")

      expect(data[:video_urls]).to eq [
        "https://assets.nintendo.com/video/upload/v1/ncom/en_US/games/switch/p/pokemon-scarlet-switch/Video/2022_6_1_Pokemon_Scarlet_Violet_Release_Date_Announcement_Four_Languages-PT"
      ]
    end

    it "scrapes rom_size" do
      data = described_class.scrap("https://game.page")

      expect(data[:rom_size]).to eq "21474836480"
    end

    it "scrapes parent_nsuids" do
      data = described_class.scrap("https://game.page")

      expect(data[:parent_nsuids]).to eq %w[70010000053971 70010000053966]
    end

    context "when page doesn`t exist" do
      it "returns an empty hash" do
        stub_request(:get, "https://game.page").to_return(body: file_fixture("pokemon-game-page.html"), status: 404)
        data = described_class.scrap("https://game.page")

        expect(data).to eq({})
      end
    end
  end
end
