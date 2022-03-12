# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'GET /games' do
    it 'has ok status' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end

  %i[on_sale new_releases coming_soon pre_order all].each do |action|
    describe "GET /games/#{action}" do
      it 'has ok status' do
        get action

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /game/:slug' do
    let(:item) { create(:item) }

    it 'has ok status' do
      get :show, params: { slug: item.slug }

      expect(response).to have_http_status(:ok)
    end
  end
end
