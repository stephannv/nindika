# frozen_string_literal: true

require "rails_helper"

RSpec.describe PreOrdersController, type: :controller do
  describe "GET /pre_orders" do
    it "has ok status" do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
