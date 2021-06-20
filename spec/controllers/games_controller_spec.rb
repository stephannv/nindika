# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'GET /games' do
    it 'has ok status' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
