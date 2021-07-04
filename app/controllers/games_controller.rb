# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[wishlist]

  def index
    list_games(filters: filters_params, sort_by: sort_param || 'popularity')
  end

  def on_sale
    list_games(
      filters: filters_params.merge(on_sale: true),
      sort_by: sort_param || 'hot'
    )
  end

  def new_releases
    list_games(
      filters: filters_params.merge(new_release: true),
      sort_by: sort_param || 'new'
    )
  end

  def coming_soon
    list_games(
      filters: filters_params.merge(coming_soon: true),
      sort_by: sort_param || 'old'
    )
  end

  def pre_order
    list_games(
      filters: filters_params.merge(pre_order: true),
      sort_by: sort_param || 'old'
    )
  end

  def wishlist
    list_games(
      filters: filters_params.merge(wishlisted: true),
      sort_by: sort_param.presence
    )
  end

  def show
    result = Items::Find.result(slug: params[:slug], user: current_user)

    @game = result.item
  end

  private

  def list_games(filters:, sort_by:)
    result = Games::List.result(
      current_user: current_user,
      filters: filters,
      sort_by: sort_by,
      page: params[:page].to_i
    )

    @games = result.games
    @pagy = Pagy.new(count: @games.total, page: params[:page], items: @games.items.presence&.size)
  end

  def filters_params
    permitted_params[:q].to_h
  end

  def sort_param
    permitted_params[:sort_by].to_s.presence
  end

  def permitted_params
    params.permit(:sort_by, q: {})
  end
end
