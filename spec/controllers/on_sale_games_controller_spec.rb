# frozen_string_literal: true

require "rails_helper"

RSpec.describe OnSaleGamesController, type: :controller do
  describe "GET /on_sale_games" do
    it "has ok status" do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
