# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpcomingGamesController, type: :controller do
  describe "GET /upcoming_games" do
    it "has ok status" do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
