# frozen_string_literal: true

require "rails_helper"

RSpec.describe Prices::CreateItemEvent, type: :operations do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(price: { type: Price }) }
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe "#call" do
    subject(:result) { described_class.result(price: price) }

    let(:price) { create(:price) }

    it "can create more than one event" do
      price.reload.update(
        base_price: price.base_price.to_i + 10,
        discount_price: 10,
        discount_percentage: 20,
        discount_ends_at: Time.zone.today
      ) # PERMANENT_PRICE_CHANGE & DISCOUNT events

      expect { result }.to change(price.item.events, :count).by(2)
    end

    context "when price or state didn`t change" do
      before { price.reload }

      it "doesn`t create item event" do
        expect(ItemEvents::Create).not_to receive(:call)

        result
      end
    end

    context "when price is newly created" do
      it "creates PRICE_ADDED item event" do
        expect(ItemEvents::Create).to receive(:call)
          .with(event_type: ItemEventTypes::PRICE_ADDED, item: price.item, price: price)

        result
      end
    end

    context "when existing price receives discount" do
      before { price.reload.update(discount_price: 10, discount_percentage: 20, discount_ends_at: Time.zone.today) }

      it "creates DISCOUNT item event" do
        expect(ItemEvents::Create).to receive(:call)
          .with(event_type: ItemEventTypes::DISCOUNT, item: price.item, price: price)

        result
      end
    end

    context "when base price changes" do
      before { price.reload.update(base_price: price.base_price.to_i + 10) }

      it "creates PERMANENT_PRICE_CHANGE item event" do
        expect(ItemEvents::Create).to receive(:call)
          .with(event_type: ItemEventTypes::PERMANENT_PRICE_CHANGE, item: price.item, price: price)

        result
      end
    end

    context "when price state changes to unavailable" do
      let(:price) { create(:price, :on_sale) }

      before { price.reload.update(state: PriceStates::UNAVAILABLE) }

      it "creates PRICE_STATE_CHANGE item event" do
        expect(ItemEvents::Create).to receive(:call)
          .with(event_type: ItemEventTypes::PRICE_STATE_CHANGE, item: price.item, price: price)

        result
      end
    end
  end
end
