# frozen_string_literal: true

require "rails_helper"

RSpec.describe WishlistItemsController, type: :controller do
  describe "POST /wishlist/:item_id" do
    login_user

    it "has ok status" do
      item = create(:item)

      post :create, params: { item_id: item.id }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE /wishlist/:item_id" do
    login_user

    it "has ok status" do
      item = create(:wishlist_item, user: current_user).item

      delete :destroy, params: { item_id: item.id }

      expect(response).to have_http_status(:ok)
    end
  end
end
