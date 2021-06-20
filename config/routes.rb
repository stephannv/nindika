# frozen_string_literal: true

Rails.application.routes.draw do
  get 'games(/:page)', to: 'games#index', as: :games
end
