# frozen_string_literal: true

Rails.application.routes.draw do
  get 'games', to: 'games#index', as: :games
  get 'game/:slug', to: 'games#show', as: :game
  get 'notifications', to: 'notifications#index', as: :notifications

  root to: 'games#index'
end
