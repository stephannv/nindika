# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "games#index"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    get :sign_in, to: "devise/sessions#new", as: :new_user_session
    delete :sign_out, to: "devise/sessions#destroy", as: :destroy_user_session
  end

  #######################################
  ##           LEGACY URL's            ##
  ## To make compatible with old URL's ##
  #######################################
  get "games/all", to: redirect("/all_games")
  get "games/on_sale", to: redirect("/on_sale_games")
  get "games/new_releases", to: redirect("/new_releases")
  get "games/coming_soon", to: redirect("/upcoming_games")
  get "games/pre_order", to: redirect("/pre_orders")
  get "game/:slug", to: redirect("/games/%{slug}")
  #######################################
  #######################################

  resources :all_games, only: :index
  resources :new_releases, only: :index
  resources :on_sale_games, only: :index
  resources :pre_orders, only: :index
  resources :upcoming_games, only: :index

  resources :analytics, only: :index
  resources :games, only: %i[index show], param: :slug
  # WISHLIST
  post "wishlist/:item_id", to: "wishlist_items#create", as: :wishlist_item
  delete "wishlist/:item_id", to: "wishlist_items#destroy"
end
