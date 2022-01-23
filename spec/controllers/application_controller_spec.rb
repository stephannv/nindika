# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'ActionPolicy::Unauthorized handling' do
    login_user

    controller do
      def create
        authorize! to: :create?, with: FeaturedGamePolicy
      end

      def implicit_authorization_target
        FeaturedGamePolicy
      end
    end

    it 'raises not found error' do
      expect do
        get :create
      end.to raise_error(ActionController::RoutingError, 'Not Found')
    end
  end
end
