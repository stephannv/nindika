# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WishlistItemsController, type: :controller do
  describe 'POST /wishlist_items/:item_id' do
    let(:item_id) { Faker::Internet.uuid }

    context 'when wishlist item is created with success' do
      login_user

      before do
        allow(WishlistItems::Create).to receive(:result)
          .with(user: current_user, item_id: item_id)
          .and_return(ServiceActor::Result.new(failure?: false))
      end

      it 'has created status' do
        post :create, params: { item_id: item_id }

        expect(response).to have_http_status(:created)
      end
    end

    context 'when wishlist item creation fails' do
      login_user

      before do
        allow(WishlistItems::Create).to receive(:result)
          .with(user: current_user, item_id: item_id)
          .and_return(ServiceActor::Result.new(failure?: true))
      end

      it 'has unprocessable_entity status' do
        post :create, params: { item_id: item_id }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user isn`t logged in' do
      it 'has unauthorized status' do
        post :create, params: { item_id: item_id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /wishlist_items/:item_id' do
    let(:item_id) { Faker::Internet.uuid }

    context 'when wishlist item is destroyed with success' do
      login_user

      before do
        allow(WishlistItems::Destroy).to receive(:result)
          .with(user: current_user, item_id: item_id)
          .and_return(ServiceActor::Result.new(failure?: false))
      end

      it 'has no content status' do
        post :destroy, params: { item_id: item_id }

        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when wishlist item destruction fails' do
      login_user

      before do
        allow(WishlistItems::Destroy).to receive(:result)
          .with(user: current_user, item_id: item_id)
          .and_return(ServiceActor::Result.new(failure?: true))
      end

      it 'has unprocessable_entity status' do
        post :destroy, params: { item_id: item_id }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user isn`t logged in' do
      it 'has unauthorized status' do
        post :destroy, params: { item_id: item_id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
