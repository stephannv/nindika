# frozen_string_literal: true

require "rails_helper"

RSpec.describe AnalyticsController, type: :controller do
  describe "GET /analytics" do
    it "has ok status" do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
