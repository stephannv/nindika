# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::List, type: :operations do
  describe "#call" do
    context "when filter params is present" do
      it "filters games" do
        game_on_sale = create(:item, :game, on_sale: true)
        game_bundle_on_sale = create(:item, :game_bundle, on_sale: true)
        filters_form = GameFiltersForm.build(on_sale: true)

        create(:item, :game_bundle, on_sale: false) # not on sale
        create(:item, :game, on_sale: false) # not on sale
        create(:item, :dlc, on_sale: true) # not a game
        create(:item, :dlc_bundle, on_sale: true) # not a game

        result = described_class.result(filters_form: filters_form)

        expect(result.items.to_a).to match_array [game_bundle_on_sale, game_on_sale]
      end
    end

    context "when sort param is present" do
      it "sorts items" do
        item_b = create(:item, :game, release_date: Time.zone.today)
        item_c = create(:item, :game_bundle, release_date: Time.zone.tomorrow)
        item_a = create(:item, :game, release_date: Time.zone.yesterday)

        result = described_class.result(sort_param: "release_date_asc")

        expect(result.items.to_a).to eq [item_a, item_b, item_c]
      end
    end

    context "when current_user is present" do
      it "fills wishlisted column" do
        user = create(:user)
        item = create(:item, :game)

        create(:wishlist_item, user: user, item: item)

        result = described_class.result(current_user: user)

        expect(result.items.first.wishlisted?).to be true
      end
    end

    context "when current_user filters only wishlisted games" do
      it "returns only wishlisted games" do
        user = create(:user)
        wishlisted_item = create(:item, :game)
        create(:item, :game) # not wishlisted game

        create(:wishlist_item, user: user, item: wishlisted_item)

        result = described_class.result(current_user: user, filters_form: GameFiltersForm.build(wishlisted: true))

        expect(result.items.to_a).to eq [wishlisted_item]
      end
    end
  end
end
