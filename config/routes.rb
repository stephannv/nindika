# frozen_string_literal: true

Rails.application.routes.draw do
  get 'games(/:page)', to: 'games#index', as: :games
  get 'game/:slug', to: 'games#show', as: :game

  get 'notifications(/:page)', to: 'notifications#index', as: :notifications

  root to: 'games#index'
end
