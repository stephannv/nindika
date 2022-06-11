# frozen_string_literal: true

require "rails_helper"

RSpec.describe VisitsCollector, type: :lib do
  describe "#all_time_game_pages_stats" do
    subject(:result) { described_class.all_time_game_pages_stats(plausible_client: plausible_client) }

    let(:plausible_client) { PlausibleClient.new }
    let(:page_1) do
      [
        { "page" => "/", "visitors" => 300 },
        { "page" => "/game/zelda", "visitors" => 10 },
        { "page" => "/game/mario", "visitors" => 12 }
      ]
    end
    let(:page_2) do
      [
        { "page" => "/game/metroid", "visitors" => 8 },
        { "page" => "/game/kirby", "visitors" => 4 },
        { "page" => "/games/on_sale", "visitors" => 20 }
      ]
    end

    before do
      allow(plausible_client).to receive(:stats_grouped_by_page)
        .with(period: Date.parse("2021-06-01")..Time.zone.today, page: 1, limit: 200)
        .and_return(page_1)

      allow(plausible_client).to receive(:stats_grouped_by_page)
        .with(period: Date.parse("2021-06-01")..Time.zone.today, page: 2, limit: 200)
        .and_return(page_2)

      allow(plausible_client).to receive(:stats_grouped_by_page)
        .with(period: Date.parse("2021-06-01")..Time.zone.today, page: 3, limit: 200)
        .and_return(nil)
    end

    it "returns all game page stats with filled slug" do
      expect(result).to eq [
        { "page" => "/game/zelda", "visitors" => 10, "slug" => "zelda" },
        { "page" => "/game/mario", "visitors" => 12, "slug" => "mario" },
        { "page" => "/game/metroid", "visitors" => 8, "slug" => "metroid" },
        { "page" => "/game/kirby", "visitors" => 4, "slug" => "kirby" }
      ]
    end
  end

  describe "#last_week_game_pages_stats" do
    subject(:result) { described_class.last_week_game_pages_stats(plausible_client: plausible_client) }

    let(:plausible_client) { PlausibleClient.new }
    let(:page_1) do
      [
        { "page" => "/", "visitors" => 300 },
        { "page" => "/game/zelda", "visitors" => 10 },
        { "page" => "/game/mario", "visitors" => 12 }
      ]
    end
    let(:page_2) do
      [
        { "page" => "/game/metroid", "visitors" => 8 },
        { "page" => "/game/kirby", "visitors" => 4 },
        { "page" => "/games/on_sale", "visitors" => 20 }
      ]
    end

    before do
      allow(plausible_client).to receive(:stats_grouped_by_page)
        .with(period: 7.days.ago..Time.zone.today, page: 1, limit: 200)
        .and_return(page_1)

      allow(plausible_client).to receive(:stats_grouped_by_page)
        .with(period: 7.days.ago..Time.zone.today, page: 2, limit: 200)
        .and_return(page_2)

      allow(plausible_client).to receive(:stats_grouped_by_page)
        .with(period: 7.days.ago..Time.zone.today, page: 3, limit: 200)
        .and_return(nil)
    end

    it "returns last week game page stats with filled slug" do
      expect(result).to eq [
        { "page" => "/game/zelda", "visitors" => 10, "slug" => "zelda" },
        { "page" => "/game/mario", "visitors" => 12, "slug" => "mario" },
        { "page" => "/game/metroid", "visitors" => 8, "slug" => "metroid" },
        { "page" => "/game/kirby", "visitors" => 4, "slug" => "kirby" }
      ]
    end
  end
end
