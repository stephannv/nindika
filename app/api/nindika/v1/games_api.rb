# frozen_string_literal: true

module Nindika
  module V1
    class GamesAPI < Grape::API
      helpers do
        def list_params
          declared(params, include_missing: false)
        end
      end

      params do
        optional :q, type: Hash do
          optional :title, type: String
          optional :genre, type: String
          optional :language, type: String

          optional :release_date_gteq, type: Date
          optional :release_date_lteq, type: Date

          optional :price_gteq, type: Integer
          optional :price_lteq, type: Integer

          optional :on_sale, type: Boolean
          optional :new_release, type: Boolean
          optional :coming_soon, type: Boolean
          optional :pre_order, type: Boolean
        end

        optional :sort_by, type: String
        optional :after, type: String
      end

      get '/games' do
        result = Games::List.result(
          filter: list_params[:q],
          sort_by: list_params[:sort_by],
          after: list_params[:after]
        )

        present :games, result.games, with: ::GameEntity
        present :total, result.total
      end

      params do
        requires :slug, type: String
      end

      get '/games/:slug' do
        result = Games::Find.result(slug: params[:slug])

        present :game, result.game, with: ::GameEntity, type: :full
      end
    end
  end
end
