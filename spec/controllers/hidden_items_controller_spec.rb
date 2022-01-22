# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HiddenItemsController, type: :controller do
  describe 'POST /hidden_items/:item_id' do
    let(:item_id) { Faker::Internet.uuid }

    context 'when hidden item is created with success' do
      login_user

      before do
        allow(HiddenItems::Create).to receive(:result)
          .with(user: current_user, item_id: item_id)
          .and_return(ServiceActor::Result.new(failure?: false))
        request.headers['HTTP_REFERER'] = on_sale_games_url
        post :create, params: { item_id: item_id }
      end

      it { is_expected.to redirect_to(on_sale_games_path) }
      it { is_expected.to set_flash[:success].to(I18n.t('hidden_items.create.success')) }
    end

    context 'when hidden item cannot be created' do
      login_user

      before do
        allow(HiddenItems::Create).to receive(:result)
          .with(user: current_user, item_id: item_id)
          .and_return(ServiceActor::Result.new(failure?: true))
        request.headers['HTTP_REFERER'] = on_sale_games_url
        post :create, params: { item_id: item_id }
      end

      it { is_expected.to redirect_to(on_sale_games_path) }
      it { is_expected.to set_flash[:danger].to(I18n.t('hidden_items.create.error')) }
    end

    context 'when user isn`t logged in' do
      before { post :create, params: { item_id: item_id } }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe 'DELETE /hidden_items/:item_id' do
    let(:item_id) { Faker::Internet.uuid }

    context 'when hidden item is destroyed' do
      login_user

      before do
        allow(HiddenItems::Destroy).to receive(:result)
          .with(user: current_user, item_id: item_id)
          .and_return(ServiceActor::Result.new(failure?: false))
        request.headers['HTTP_REFERER'] = on_sale_games_url
        post :destroy, params: { item_id: item_id }
      end

      it { is_expected.to redirect_to(on_sale_games_path) }
      it { is_expected.to set_flash[:success].to(I18n.t('hidden_items.destroy.success')) }
    end

    context 'when hidden cannot be destroyed' do
      login_user

      before do
        allow(HiddenItems::Destroy).to receive(:result)
          .with(user: current_user, item_id: item_id)
          .and_return(ServiceActor::Result.new(failure?: true))
        request.headers['HTTP_REFERER'] = on_sale_games_url
        post :destroy, params: { item_id: item_id }
      end

      it { is_expected.to redirect_to(on_sale_games_path) }
      it { is_expected.to set_flash[:danger].to(I18n.t('hidden_items.destroy.error')) }
    end

    context 'when user isn`t logged in' do
      before { post :destroy, params: { item_id: item_id } }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
