# frozen_string_literal: true

require "rails_helper"

RSpec.describe WishlistItems::Destroy, type: :operation do
  describe ".result" do
    context "when item is in wishlist" do
      it "is successful" do
        user = create(:user)
        item = create(:item)
        create(:wishlist_item, user: user, item: item)

        result = described_class.result(user: user, item_id: item.id)

        expect(result.success?).to be true
      end

      it "removes item from user's wishlist" do
        user = create(:user)
        item = create(:item)
        create(:wishlist_item, user: user, item: item)

        described_class.result(user: user, item_id: item.id)

        expect(user.wishlist_items.find_by(item_id: item.id)).to be_nil
      end
    end

    context "when item isn't in wishlist" do
      it "fails" do
        user = create(:user)
        item = create(:item)

        result = described_class.result(user: user, item_id: item.id)

        expect(result.failure?).to be true
      end

      it "doesn't remove a wishlist item" do
        user = create(:user)
        item = create(:item)

        expect do
          described_class.result(user: user, item_id: item.id)
        end.not_to change(WishlistItem, :count)
      end
    end
  end
end
