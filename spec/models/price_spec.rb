# frozen_string_literal: true

require "rails_helper"

RSpec.describe Price, type: :model do
  describe "Relations" do
    it { is_expected.to belong_to(:item) }

    it { is_expected.to have_many(:history_items).class_name("PriceHistoryItem").dependent(:destroy) }
  end

  describe "Configurations" do
    it { is_expected.to monetize(:base_price) }
    it { is_expected.to monetize(:discount_price).allow_nil }
    it { is_expected.to monetize(:discounted_amount).allow_nil }

    it "has state enum" do
      expect(described_class.enumerations).to include(state: PriceStates)
    end
  end

  describe "Validations" do
    subject(:price) { build(:price) }

    it { is_expected.to validate_presence_of(:item_id) }
    it { is_expected.to validate_presence_of(:nsuid) }
    it { is_expected.to validate_presence_of(:state) }

    it { is_expected.to validate_uniqueness_of(:item_id).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:nsuid).case_insensitive }

    it { is_expected.to validate_numericality_of(:base_price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:discount_price).is_greater_than_or_equal_to(0) }
  end

  describe "#eshop_url" do
    it "returns eShop URL using nsuid" do
      price = described_class.new(nsuid: "123")

      expect(price.eshop_url).to eq "https://ec.nintendo.com/title_purchase_confirm?title=123"
    end
  end

  describe "#current_price" do
    context "when discount amount is present" do
      it "returns discount amount" do
        price = described_class.new(base_price: Money.new(100), discount_price: Money.new(50))
        expect(price.current_price).to eq Money.new(50)
      end
    end

    context "when discount amount is nil" do
      it "returns base_price" do
        price = described_class.new(base_price: Money.new(100), discount_price: nil)
        expect(price.current_price).to eq Money.new(100)
      end
    end
  end

  describe "saved_change_to_current_price?" do
    let(:price) { described_class.new }

    before do
      allow(price).to receive(:saved_change_to_base_price_cents?).and_return(false)
      allow(price).to receive(:saved_change_to_discount_price_cents?).and_return(false)
    end

    context "when changes for base_price_cents was saved" do
      before { allow(price).to receive(:saved_change_to_base_price_cents?).and_return(true) }

      it "returns true" do
        expect(price.saved_change_to_current_price?).to be(true)
      end
    end

    context "when changes for discount_price_cents was saved" do
      before { allow(price).to receive(:saved_change_to_discount_price_cents?).and_return(true) }

      it "returns true" do
        expect(price.saved_change_to_current_price?).to be(true)
      end
    end

    context "when changes for base_price_cents and discount_price_cents wasn`t saved" do
      it "returns false" do
        expect(price.saved_change_to_current_price?).to be(false)
      end
    end
  end

  describe "#discount?" do
    context "when discount amount is present" do
      it "returns true" do
        price = described_class.new(discount_price: 10)

        expect(price.discount?).to be true
      end
    end

    context "when discount amount is blank" do
      it "returns false" do
        price = described_class.new(discount_price: nil)

        expect(price.discount?).to be false
      end
    end
  end
end
