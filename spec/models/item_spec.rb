# frozen_string_literal: true

require "rails_helper"

RSpec.describe Item, type: :model do
  describe "Relations" do
    it { is_expected.to have_one(:raw_item).dependent(:destroy) }
    it { is_expected.to have_one(:price).dependent(:destroy) }

    it do
      expect(described_class.new).to have_many(:parent_relationships)
        .class_name("ItemRelationship")
        .with_foreign_key(:parent_id)
        .dependent(:destroy)
    end

    it do
      expect(described_class.new).to have_many(:child_relationships)
        .class_name("ItemRelationship")
        .with_foreign_key(:child_id)
        .dependent(:destroy)
    end

    it { is_expected.to have_many(:events).class_name("ItemEvent").dependent(:destroy) }

    it { is_expected.to have_many(:parents).class_name("Item").through(:child_relationships).source(:parent) }
    it { is_expected.to have_many(:children).class_name("Item").through(:parent_relationships).source(:child) }
    it { is_expected.to have_many(:price_history_items).through(:price).source(:history_items) }
  end

  describe "Configurations" do
    it { is_expected.to monetize(:current_price).allow_nil }
  end

  describe "Validations" do
    subject(:item) { build(:item) }

    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_uniqueness_of(:external_id) }

    it { is_expected.to validate_length_of(:external_id).is_at_most(256) }
    it { is_expected.to validate_length_of(:title).is_at_most(1024) }
    it { is_expected.to validate_length_of(:description).is_at_most(8192) }
    it { is_expected.to validate_length_of(:nsuid).is_at_most(32) }
  end

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
  end

  describe "Friendly ID" do
    let!(:item_a) { create(:item, title: "Some title", slug: nil) }
    let!(:item_b) { create(:item, title: "Other title", slug: nil) }

    before do
      item_a.update(title: "New title")
    end

    it "finds record with given slug" do
      expect(described_class.friendly.find("other-title")).to eq item_b
    end

    it "finds record using slug history" do
      expect(described_class.friendly.find("some-title")).to eq item_a
    end

    it "generates new slug when title changes" do
      expect(described_class.friendly.find("new-title")).to eq item_a
    end
  end

  describe "#to_param" do
    it "uses slug" do
      item = described_class.new(id: Faker::Internet.uuid, slug: "some-slug")
      expect(item.to_param).to eq "some-slug"
    end
  end

  describe "#release_date_text" do
    context "when release_date_date is a valid date" do
      it "returns formatted date" do
        item = described_class.new(release_date_display: "2022-04-01")

        expect(item.release_date_text).to eq "01/04/2022"
      end
    end

    context "when release_date_date is an invalid date" do
      it "returns release_date_display" do
        item = described_class.new(release_date_display: "invalid-date")

        expect(item.release_date_text).to eq "invalid-date"
      end
    end
  end

  describe "#small_banner_url" do
    it "replaces w_720 to w_480 from banner url" do
      item = described_class.new(banner_url: "my.url/w_720/image")

      expect(item.small_banner_url).to eq "my.url/w_480/image"
    end
  end
end
