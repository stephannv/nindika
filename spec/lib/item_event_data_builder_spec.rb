# frozen_string_literal: true

require "rails_helper"

RSpec.describe ItemEventDataBuilder, type: :lib do
  subject(:data) { described_class.build(event_type: event_type, item: item, price: price) }

  let(:price) { nil }

  context "when event type is ITEM_ADDED" do
    let(:event_type) { ItemEventTypes::ITEM_ADDED }
    let(:item) { build(:item) }

    it "is blank" do
      expect(data).to eq({})
    end
  end

  context "when event type is PRICE_ADDED" do
    let(:event_type) { ItemEventTypes::PRICE_ADDED }
    let(:item) { build(:item) }
    let(:price) { build(:price, :with_discount) }

    it "has current_price attribute" do
      expect(data[:current_price]).to eq price.current_price.formatted
    end

    it "has state attribute" do
      expect(data[:state]).to eq price.state_humanize
    end

    context "when price has discount" do
      it "has base_price attribute" do
        expect(data[:base_price]).to eq price.base_price.formatted
      end

      it "has discount_percentage attribute" do
        expect(data[:discount_percentage]).to eq "#{price.discount_percentage}%"
      end

      it "has discount_ends_at attribute" do
        expect(data[:discount_ends_at]).to eq I18n.l(price.discount_ends_at, format: :shorter)
      end
    end

    context "when price doesn`t have discount" do
      let(:price) { build(:price) }

      it "doesn`t have base_price attribute" do
        expect(data).not_to have_key(:base_price)
      end

      it "doesn`t have discount_percentage attribute" do
        expect(data).not_to have_key(:discount_percentage)
      end

      it "doesn`t have discount_ends_at attribute" do
        expect(data).not_to have_key(:discount_ends_at)
      end
    end
  end

  context "when event type is DISCOUNT" do
    let(:event_type) { ItemEventTypes::DISCOUNT }
    let(:item) { build(:item) }
    let(:price) { build(:price, :with_discount) }

    it "has current_price attribute" do
      expect(data[:current_price]).to eq price.current_price.formatted
    end

    context "when price has discount" do
      it "has base_price attribute" do
        expect(data[:base_price]).to eq price.base_price.formatted
      end

      it "has discount_percentage attribute" do
        expect(data[:discount_percentage]).to eq "#{price.discount_percentage}%"
      end

      it "has discount_ends_at attribute" do
        expect(data[:discount_ends_at]).to eq I18n.l(price.discount_ends_at, format: :shorter)
      end
    end

    context "when price doesn`t have discount" do
      let(:price) { build(:price) }

      it "doesn`t have base_price attribute" do
        expect(data).not_to have_key(:base_price)
      end

      it "doesn`t have discount_percentage attribute" do
        expect(data).not_to have_key(:discount_percentage)
      end

      it "doesn`t have discount_ends_at attribute" do
        expect(data).not_to have_key(:discount_ends_at)
      end
    end
  end

  context "when event type is PERMANENT_PRICE_CHANGE" do
    let(:event_type) { ItemEventTypes::PERMANENT_PRICE_CHANGE }
    let(:price) { create(:price, base_price: 200) }
    let(:item) { price.item }

    before do
      price.reload.update(base_price: 100)
    end

    it "has current_price attribute" do
      expect(data[:current_price]).to eq "R$ 100,00"
    end

    it "has old_price attribute" do
      expect(data[:old_price]).to eq "R$ 200,00"
    end
  end

  context "when event type is PRICE_STATE_CHANGE" do
    let(:event_type) { ItemEventTypes::PRICE_STATE_CHANGE }
    let(:item) { build(:item) }
    let(:price) { build(:price) }

    it "has current_price attribute" do
      expect(data[:current_price]).to eq price.current_price.formatted
    end
  end
end
