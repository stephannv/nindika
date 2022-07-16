# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::WithWishlistedColumnQuery, type: :query do
  describe ".call" do
    context "when item is wishlisted" do
      it "fills item's wishlisted attribute as true" do
        user = create(:user)
        item = create(:item)
        create(:wishlist_item, user: user, item: item)

        relation = described_class.call(user_id: user.id)

        expect(relation.first.wishlisted).to be true
      end
    end

    context "when item isn't wishlisted" do
      it "fills item's wishlisted attribute as false" do
        user = create(:user)
        create(:item)

        relation = described_class.call(user_id: user.id)

        expect(relation.first.wishlisted).to be false
      end
    end

    context "when item is wishlisted by another user" do
      it "fills item's wishlisted attribute as false" do
        user = create(:user)
        another_user = create(:user)
        item = create(:item)
        create(:wishlist_item, user: another_user, item: item)

        relation = described_class.call(user_id: user.id)

        expect(relation.first.wishlisted).to be false
      end
    end

    context "when only_wishlisted is true" do
      it "returns only wishlisted items by given user" do
        user = create(:user)
        another_user = create(:user)
        wishlisted_items = create_list(:item, 2)
        not_wishedlisted_items = create_list(:item, 2)
        wishlisted_items.each { |i| create(:wishlist_item, item: i, user: user) }
        create(:wishlist_item, item: not_wishedlisted_items.first, user: another_user) # wishlisted by another user

        relation = described_class.call(user_id: user.id, only_wishlisted: true)

        expect(relation.to_a).to match wishlisted_items
      end
    end

    context "when only_wishlisted is false" do
      it "returns all items" do
        user = create(:user)
        another_user = create(:user)
        wishlisted_items = create_list(:item, 2)
        not_wishedlisted_items = create_list(:item, 2)
        wishlisted_items.each { |i| create(:wishlist_item, item: i, user: user) }
        create(:wishlist_item, item: not_wishedlisted_items.first, user: another_user) # wishlisted by another user

        relation = described_class.call(user_id: user.id, only_wishlisted: false)

        expect(relation.to_a).to match(wishlisted_items + not_wishedlisted_items)
      end
    end
  end
end
