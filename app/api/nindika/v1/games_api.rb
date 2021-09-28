# frozen_string_literal: true

module Nindika
  module V1
    class GamesAPI < Grape::API
      get '/games' do
        result = Items::List.result

        present :games, result.items, with: ::GameEntity
      end
    end
  end
end
