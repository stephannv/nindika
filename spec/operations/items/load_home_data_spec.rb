# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::LoadHomeData, type: :operations do
  describe "#call" do
    it "loads featured games" do
      featured_games = create_list(:item, 25, :game, wishlists_count: 100)
      featured_game_bundles = create_list(:item, 25, :game_bundle, wishlists_count: 100)
      create_list(:item, 25, :game, wishlists_count: 0) # not featured games
      create(:item, :dlc, wishlists_count: 200) # not game
      create(:item, :dlc_bundle, wishlists_count: 200) # not game

      result = described_class.result

      featured_ids = featured_games.pluck(:id) + featured_game_bundles.pluck(:id)
      expect(featured_ids).to include(*result.featured_games.pluck(:id))
    end

    it "loads coming soon games" do
      coming_soon_games = create_list(:item, 2, :game, coming_soon: true)
      coming_soon_game_bundles = create_list(:item, 2, :game_bundle, coming_soon: true)
      create_list(:item, 2, :game, coming_soon: false) # not coming soon games
      create(:item, :dlc, coming_soon: true) # not game
      create(:item, :dlc_bundle, coming_soon: true) # not game

      result = described_class.result

      expect(result.coming_soon_games.to_a).to match_array coming_soon_games + coming_soon_game_bundles
    end

    it "loads new releases games" do
      new_releases_games = create_list(:item, 2, :game, new_release: true)
      new_releases_game_bundles = create_list(:item, 2, :game_bundle, new_release: true)
      create_list(:item, 2, :game, new_release: false) # not new releases games
      create(:item, :dlc, new_release: true) # not game
      create(:item, :dlc_bundle, new_release: true) # not game

      result = described_class.result

      expect(result.new_releases_games.to_a).to match_array new_releases_games + new_releases_game_bundles
    end

    it "loads on sale games" do
      on_sale_games = create_list(:item, 2, :game, :with_price, on_sale: true)
      on_sale_game_bundles = create_list(:item, 2, :game_bundle, :with_price, on_sale: true)
      create_list(:item, 2, :game, on_sale: false) # not on sale games
      create(:item, :dlc, on_sale: true) # not game
      create(:item, :dlc_bundle, on_sale: true) # not game

      result = described_class.result

      expect(result.on_sale_games.to_a).to match_array on_sale_games + on_sale_game_bundles
    end

    it "loads new games" do
      new_games = create_list(:item, 2, :game, created_at: Time.zone.now)
      new_game_bundles = create_list(:item, 2, :game_bundle, created_at: Time.zone.now)
      create_list(:item, 2, :game, created_at: 1.year.ago) # not new games
      create(:item, :dlc, created_at: 2.minutes.from_now) # not game
      create(:item, :dlc_bundle, created_at: 2.minutes.from_now) # not game

      result = described_class.result

      expect(result.new_games.to_a).to match_array new_games + new_game_bundles
    end

    context "when current_user is present" do
      it "fills wishlisted column" do
        user = create(:user)
        new_game = create(:item, :game, created_at: Time.zone.now)
        create(:wishlist_item, user: user, item: new_game)

        result = described_class.result(current_user: user)

        expect(result.new_games.first.wishlisted?).to be true
      end
    end
  end
end
