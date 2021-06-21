# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe 'GET /notifications' do
    it 'has ok status' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
