# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  describe 'GET /notifications/all' do
    it 'has ok status' do
      get :all

      expect(response).to have_http_status(:ok)
    end
  end
end
