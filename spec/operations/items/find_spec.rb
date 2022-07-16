# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::Find, type: :operations do
  describe "#call" do
    context "when item with given slug exists" do
      it "returns found item" do
        item = create(:item)
        result = described_class.result(slug: item.slug)

        expect(result.item).to eq item
      end
    end

    context "when item is wishlisted by current_user" do
      it "fills wishlisted attribute as true" do
        user = create(:user)
        item = create(:wishlist_item, user: user).item

        result = described_class.result(slug: item.slug, current_user: user)

        expect(result.item.wishlisted?).to be true
      end
    end

    context "when item isn't wishlisted by current_user" do
      it "fills wishlisted attribute as false" do
        user = create(:user)
        item = create(:item)

        result = described_class.result(slug: item.slug, current_user: user)

        expect(result.item.wishlisted?).to be false
      end
    end

    context "when item with given slug doesn`t exist" do
      it "raises not found error" do
        expect { described_class.result(slug: "not-found-slug") }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
