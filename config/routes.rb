# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'games#index'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get :sign_in, to: 'devise/sessions#new', as: :new_user_session
    delete :sign_out, to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  scope :games do
    get '/', to: 'games#index', as: :games
    get 'on_sale', to: 'games#index', as: :on_sale_games, defaults: { q: { on_sale: true } }
    get 'new_releases', to: 'games#index', as: :new_releases_games, defaults: { q: { new_release: true } }
    get 'coming_soon', to: 'games#index', as: :coming_soon_games, defaults: { q: { coming_soon: true } }
    get 'pre_order', to: 'games#index', as: :pre_order_games, defaults: { q: { pre_order: true } }
  end

  get 'game/:slug', to: 'games#show', as: :game
  get 'notifications', to: 'notifications#index', as: :notifications

  scope :wishlist do
    post 'add/:item_id', to: 'wishlist_items#create', as: :add_wishlist_item
    delete 'remove/:item_id', to: 'wishlist_items#destroy', as: :remove_wishlist_item
  end
  scope :hidden_items do
    post 'add/:item_id', to: 'hidden_items#create', as: :add_hidden_item
    delete 'remove/:item_id', to: 'hidden_items#destroy', as: :remove_hidden_item
  end
end
