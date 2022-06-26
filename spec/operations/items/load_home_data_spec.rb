# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::LoadHomeData, type: :operations do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to include(trending_games: { type: Enumerable }) }
    it { is_expected.to include(coming_soon_games: { type: Enumerable }) }
    it { is_expected.to include(new_releases_games: { type: Enumerable }) }
    it { is_expected.to include(on_sale_games: { type: Enumerable }) }
    it { is_expected.to include(new_games: { type: Enumerable }) }
  end

  describe "#call" do
    subject(:result) { described_class.result }

    it "loads trending games" do
      trending_games = create_list(:item, 2, :game, last_week_visits: 100)
      trending_game_bundles = create_list(:item, 1, :game_bundle, last_week_visits: 100)
      create_list(:item, 2, :game, last_week_visits: 0) # not trending games
      create(:item, :dlc, last_week_visits: 200) # not game
      create(:item, :dlc_bundle, last_week_visits: 200) # not game

      expect(result.trending_games.to_a).to match_array(trending_games + trending_game_bundles)
    end

    it "loads coming soon games" do
      coming_soon_games = create_list(:item, 2, :game, coming_soon: true)
      coming_soon_game_bundles = create_list(:item, 2, :game_bundle, coming_soon: true)
      create_list(:item, 2, :game, coming_soon: false) # not coming soon games
      create(:item, :dlc, coming_soon: true) # not game
      create(:item, :dlc_bundle, coming_soon: true) # not game

      expect(result.coming_soon_games.to_a).to match_array coming_soon_games + coming_soon_game_bundles
    end

    it "loads new releases games" do
      new_releases_games = create_list(:item, 2, :game, new_release: true)
      new_releases_game_bundles = create_list(:item, 2, :game_bundle, new_release: true)
      create_list(:item, 2, :game, new_release: false) # not new releases games
      create(:item, :dlc, new_release: true) # not game
      create(:item, :dlc_bundle, new_release: true) # not game

      expect(result.new_releases_games.to_a).to match_array new_releases_games + new_releases_game_bundles
    end

    it "loads on sale games" do
      on_sale_games = create_list(:item, 2, :game, :with_price, on_sale: true)
      on_sale_game_bundles = create_list(:item, 2, :game_bundle, :with_price, on_sale: true)
      create_list(:item, 2, :game, on_sale: false) # not on sale games
      create(:item, :dlc, on_sale: true) # not game
      create(:item, :dlc_bundle, on_sale: true) # not game

      expect(result.on_sale_games.to_a).to match_array on_sale_games + on_sale_game_bundles
    end

    it "loads new games" do
      new_games = create_list(:item, 2, :game, created_at: Time.zone.now)
      new_game_bundles = create_list(:item, 2, :game_bundle, created_at: Time.zone.now)
      create_list(:item, 2, :game, created_at: 1.year.ago) # not new games
      create(:item, :dlc, created_at: 2.minutes.from_now) # not game
      create(:item, :dlc_bundle, created_at: 2.minutes.from_now) # not game

      expect(result.new_games.to_a).to match_array new_games + new_game_bundles
    end
  end
end
