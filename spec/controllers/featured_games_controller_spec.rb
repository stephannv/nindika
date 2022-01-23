# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeaturedGamesController, type: :controller do
  describe 'POST /games/:id/feature' do
    let(:id) { Faker::Internet.uuid }

    context 'when game is featured with success' do
      login_admin

      before do
        allow(Items::Update).to receive(:result)
          .with(id: id, attributes: { featured: true })
          .and_return(ServiceActor::Result.new(failure?: false))
      end

      it 'has created status' do
        post :create, params: { id: id }

        expect(response).to have_http_status(:created)
      end
    end

    context 'when wishlist item creation fails' do
      login_admin

      before do
        allow(Items::Update).to receive(:result)
          .with(id: id, attributes: { featured: true })
          .and_return(ServiceActor::Result.new(failure?: true))
      end

      it 'has unprocessable_entity status' do
        post :create, params: { id: id }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user isn`t admin' do
      login_user

      it 'has not_found status' do
        expect do
          post :create, params: { id: id }
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe 'DELETE /games/:id/feature' do
    let(:id) { Faker::Internet.uuid }

    context 'when wishlist item is destroyed with success' do
      login_admin

      before do
        allow(Items::Update).to receive(:result)
          .with(id: id, attributes: { featured: false })
          .and_return(ServiceActor::Result.new(failure?: false))
      end

      it 'has no content status' do
        post :destroy, params: { id: id }

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when wishlist item destruction fails' do
      login_admin

      before do
        allow(Items::Update).to receive(:result)
          .with(id: id, attributes: { featured: false })
          .and_return(ServiceActor::Result.new(failure?: true))
      end

      it 'has unprocessable_entity status' do
        post :destroy, params: { id: id }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user isn`t logged in' do
      login_user

      it 'has unauthorized status' do
        expect do
          delete :destroy, params: { id: id }
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
