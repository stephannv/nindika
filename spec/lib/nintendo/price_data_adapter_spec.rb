# frozen_string_literal: true

require "rails_helper"

RSpec.describe Nintendo::PriceDataAdapter, type: :lib do
  prices_data = {
    id: "1234",
    sales_status: "onsale",
    price: {
      regular_price: {
        raw_value: 50,
        currency: "BRL"
      },
      discount_price: {
        raw_value: 20,
        currency: "BRL",
        start_datetime: Time.zone.yesterday.to_s,
        end_datetime: Time.zone.tomorrow.to_s
      },
      gold_point: {
        gift_gp: 123
      }
    }
  }.deep_stringify_keys.freeze

  describe "#nsuid" do
    it "returns id" do
      adapted_data = described_class.adapt(prices_data)

      expect(adapted_data[:nsuid]).to eq "1234"
    end
  end

  describe "#base_price" do
    context "when regular price is present" do
      it "returns regular price as money object" do
        adapted_data = described_class.adapt(prices_data)

        expect(adapted_data[:base_price]).to eq Money.new(5000, "BRL")
      end
    end

    context "when regular price is nil" do
      it "returns nil" do
        data = prices_data.deep_merge("price" => { "regular_price" => nil, "discount_price" => nil })

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:base_price]).to be_nil
      end
    end
  end

  describe "#discount_price" do
    context "when discount price is present" do
      it "returns discount price as money object" do
        adapted_data = described_class.adapt(prices_data)

        expect(adapted_data[:discount_price]).to eq Money.new(2000, "BRL")
      end
    end

    context "when discount price is nil" do
      it "returns nil" do
        data = prices_data.deep_merge("price" => { "discount_price" => nil })

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:discount_price]).to be_nil
      end
    end
  end

  describe "#discount_started_at" do
    context "when discount price is present" do
      it "returns discount start date as date object" do
        adapted_data = described_class.adapt(prices_data)

        expect(adapted_data[:discount_started_at]).to eq Time.zone.yesterday.beginning_of_day
      end
    end

    context "when discount price is nil" do
      it "returns nil" do
        data = prices_data.deep_merge("price" => { "discount_price" => nil })

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:discount_started_at]).to be_nil
      end
    end
  end

  describe "#discount_ends_at" do
    context "when discount price is present" do
      it "returns discount end date as date object" do
        adapted_data = described_class.adapt(prices_data)

        expect(adapted_data[:discount_ends_at]).to eq Time.zone.tomorrow.beginning_of_day
      end
    end

    context "when discount price is nil" do
      it "returns nil" do
        data = prices_data.deep_merge("price" => { "discount_price" => nil })

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:discount_ends_at]).to be_nil
      end
    end
  end

  describe "#discounted_amount" do
    context "when discount price is present" do
      it "returns diff between regular price and discount price" do
        adapted_data = described_class.adapt(prices_data)

        expect(adapted_data[:discounted_amount]).to eq Money.new(3000, "BRL")
      end
    end

    context "when discount price is nil" do
      it "returns nil" do
        data = prices_data.deep_merge("price" => { "discount_price" => nil })

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:discounted_amount]).to be_nil
      end
    end
  end

  describe "#discount_percentage" do
    context "when discount price is present" do
      it "returns discount percentage" do
        adapted_data = described_class.adapt(prices_data)

        expect(adapted_data[:discount_percentage]).to eq 60
      end
    end

    context "when discount price is nil" do
      it "returns nil" do
        data = prices_data.deep_merge("price" => { "discount_price" => nil })

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:discount_percentage]).to be_nil
      end
    end
  end

  describe "#state" do
    context "when state status is not_found" do
      it "returns PriceStates::UNAVAILABLE" do
        data = prices_data.merge("sales_status" => "not_found")

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:state]).to eq PriceStates::UNAVAILABLE
      end
    end

    context "when state status is not_sale" do
      it "returns PriceStates::UNAVAILABLE" do
        data = prices_data.merge("sales_status" => "not_sale")

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:state]).to eq PriceStates::UNAVAILABLE
      end
    end

    context "when state status is sales_termination" do
      it "returns PriceStates::UNAVAILABLE" do
        data = prices_data.merge("sales_status" => "sales_termination")

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:state]).to eq PriceStates::UNAVAILABLE
      end
    end

    context "when state status is onsale" do
      it "returns PriceStates::ON_SALE" do
        data = prices_data.merge("sales_status" => "onsale")

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:state]).to eq PriceStates::ON_SALE
      end
    end

    context "when state status is pre_order" do
      it "returns PriceStates::PRE_ORDER" do
        data = prices_data.merge("sales_status" => "pre_order")

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:state]).to eq PriceStates::PRE_ORDER
      end
    end

    context "when state status is preorder" do
      it "returns PriceStates::PRE_ORDER" do
        data = prices_data.merge("sales_status" => "preorder")

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:state]).to eq PriceStates::PRE_ORDER
      end
    end

    context "when state status is unreleased" do
      it "returns PriceStates::UNRELEASED" do
        data = prices_data.merge("sales_status" => "unreleased")

        adapted_data = described_class.adapt(data)

        expect(adapted_data[:state]).to eq PriceStates::UNRELEASED
      end
    end

    context "when state is not mapped" do
      it "raises error" do
        data = prices_data.merge("sales_status" => "my_status")

        expect { described_class.adapt(data) }.to raise_error("my_status NOT MAPPED PRICE STATE")
      end
    end
  end

  describe "#golden_points" do
    it "returns gift_gp" do
      adapted_data = described_class.adapt(prices_data)

      expect(adapted_data[:gold_points]).to eq 123
    end
  end
end
