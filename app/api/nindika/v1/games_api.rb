# frozen_string_literal: true

module Nindika
  module V1
    class GamesAPI < Grape::API
      get '/games' do
        result = Games::List.result

        present :games, result.games, with: ::GameEntity
      end
    end
  end
end
