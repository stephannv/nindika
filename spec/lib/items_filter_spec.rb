# frozen_string_literal: true

require "rails_helper"

RSpec.describe ItemsFilter, type: :lib do
  describe "#apply" do
    subject(:result) { described_class.apply(relation: Item, filters_form: filters_form) }

    context "when title is present" do
      let(:filters_form) { GameFiltersForm.build(title: "leslie") }
      let!(:item) { create(:item, title: "As confusões de Leslie") }

      before { create_list(:item, 3, :with_price) }

      it "returns items filtering by title" do
        expect(result.to_a).to eq [item]
      end
    end

    context "when release_date range is present" do
      let(:filters_form) do
        GameFiltersForm.build(release_date_gteq: 2.months.ago, release_date_lteq: Time.zone.tomorrow)
      end
      let!(:item_a) { create(:item, release_date: 1.month.ago) }
      let!(:item_b) { create(:item, release_date: Time.zone.today) }

      before { create(:item, release_date: 1.month.from_now) }

      it "returns items filtering by release date range" do
        expect(result.to_a).to eq [item_a, item_b]
      end
    end

    context "when price range is present" do
      let(:filters_form) { GameFiltersForm.build(price_gteq: 9, price_lteq: 22) }
      let!(:item_a) { create(:item, current_price: 10) }
      let!(:item_b) { create(:item, current_price: 20) }

      before { create(:item, current_price: 30) }

      it "returns items filtering by price range" do
        expect(result.to_a).to match_array([item_a, item_b])
      end
    end

    context "when genre is present" do
      let(:filters_form) { GameFiltersForm.build(genre: "action") }
      let!(:item_a) { create(:item, genres: %w[action racing]) }
      let!(:item_c) { create(:item, genres: %w[action]) }

      before { create(:item, genres: %w[role_playing]) }

      it "returns items filtering by genre" do
        expect(result.to_a).to match [item_a, item_c]
      end
    end

    context "when language is present" do
      let(:filters_form) { GameFiltersForm.build(language: "PT") }

      let!(:item_a) { create(:item, languages: %w[PT]) }
      let!(:item_c) { create(:item, languages: %w[PT EN JP]) }

      before { create(:item, languages: %w[EN JP ES]) }

      it "returns items filtering by language" do
        expect(result.to_a).to eq [item_a, item_c]
      end
    end

    context "when on_sale param is true" do
      let(:filters_form) { GameFiltersForm.build(on_sale: true) }
      let!(:item) { create(:item, on_sale: true) }

      before { create_list(:item, 3, on_sale: false) }

      it "returns items on sale" do
        expect(result.to_a).to eq [item]
      end
    end

    context "when new_release param is true" do
      let(:filters_form) { GameFiltersForm.build(new_release: true) }
      let!(:item) { create(:item, new_release: true) }

      before { create_list(:item, 3, new_release: false) }

      it "returns new releases items" do
        expect(result.to_a).to eq [item]
      end
    end

    context "when coming_soon param is true" do
      let(:filters_form) { GameFiltersForm.build(coming_soon: true) }
      let!(:item) { create(:item, coming_soon: true) }

      before { create_list(:item, 3, coming_soon: false) }

      it "returns coming soon items" do
        expect(result.to_a).to eq [item]
      end
    end

    context "when pre_order param is true" do
      let(:filters_form) { GameFiltersForm.build(pre_order: true) }
      let!(:item) { create(:item, pre_order: true) }

      before { create_list(:item, 3, pre_order: false) }

      it "returns pre order items" do
        expect(result.to_a).to eq [item]
      end
    end
  end
end
