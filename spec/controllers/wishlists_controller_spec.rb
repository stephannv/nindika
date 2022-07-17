# frozen_string_literal: true

require "rails_helper"

RSpec.describe WishlistsController, type: :controller do
  describe "GET /wishlist" do
    login_user

    it "has ok status" do
      get :show

      expect(response).to have_http_status(:ok)
    end
  end
end
