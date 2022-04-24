# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewReleasesController, type: :controller do
  describe 'GET /new_releases' do
    it 'has ok status' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
