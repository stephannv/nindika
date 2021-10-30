# frozen_string_literal: true

module Nindika
  module V1
    class GamesAPI < Grape::API
      params do
        optional :sort_by, type: String
        optional :after, type: String
      end

      get '/games' do
        result = Games::List.result(sort_by: params[:sort_by], after: params[:after])

        present :games, result.games, with: ::GameEntity
        present :total, result.total
      end
    end
  end
end
