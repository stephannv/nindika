# frozen_string_literal: true

require "rails_helper"

RSpec.describe Item, type: :model do
  describe "Scopes" do
    describe ".with_nsuid" do
      let!(:with_nsuid) { create(:item) }

      before { create(:item, nsuid: nil) }

      it "returns items with nsuid" do
        expect(described_class.with_nsuid.to_a).to eq [with_nsuid]
      end
    end

    describe ".on_sale" do
      let!(:on_sale) { create(:item, on_sale: true) }

      before { create(:item, on_sale: false) }

      it "returns items on sale" do
        expect(described_class.on_sale.to_a).to eq [on_sale]
      end
    end

    describe ".new_release" do
      let!(:new_release) { create(:item, new_release: true) }

      before { create(:item, new_release: false) }

      it "returns newly released items" do
        expect(described_class.new_release.to_a).to eq [new_release]
      end
    end

    describe ".coming_soon" do
      let!(:coming_soon) { create(:item, coming_soon: true) }

      before { create(:item, coming_soon: false) }

      it "returns coming soon items" do
        expect(described_class.coming_soon.to_a).to eq [coming_soon]
      end
    end

    describe ".pre_order" do
      let!(:pre_order) { create(:item, pre_order: true) }

      before { create(:item, pre_order: false) }

      it "returns pre order items" do
        expect(described_class.pre_order.to_a).to eq [pre_order]
      end
    end

    describe ".pending_scrap" do
      let!(:not_scraped) { create(:item, last_scraped_at: nil) }
      let!(:scraped_long_ago) { create(:item, last_scraped_at: 25.hours.ago) }

      before { create(:item, last_scraped_at: 23.hours.ago) } # scraped recently

      it "returns not scraped items or scraped more than 24 hours ago" do
        expect(described_class.pending_scrap.to_a).to match_array [not_scraped, scraped_long_ago]
      end
    end

    describe ".with_prices" do
      let!(:item_with_price) { create(:item, :with_price) }

      before { create(:item) } # item without price

      it "returns items with price" do
        expect(described_class.with_prices.to_a).to match_array [item_with_price]
      end

      it "preloads prices" do
        items = described_class.with_prices.to_a

        expect { items.each(&:price) }.to not_talk_to_db
      end
    end

    describe ".including_prices" do
      let!(:item_with_price) { create(:item, :with_price) }
      let!(:item_without_price) { create(:item) }

      it "returns all items" do
        expect(described_class.including_prices.to_a).to match_array [item_with_price, item_without_price]
      end

      it "preloads prices" do
        items = described_class.including_prices.to_a

        expect { items.each(&:price) }.to not_talk_to_db
      end
    end

    describe ".with_wishlisted_column" do
      it "delegates query to WithWishlistedColumnQuery" do
        expect(Items::WithWishlistedColumnQuery).to receive(:call).with(user_id: "user-id", only_wishlisted: true)

        described_class.with_wishlisted_column(user_id: "user-id", only_wishlisted: true)
      end
    end
  end
end
