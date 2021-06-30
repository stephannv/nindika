# frozen_string_literal: true

class GamesController < ApplicationController
  include Pagy::Backend

  before_action :authenticate_user!, only: %i[wishlist]

  def index
    list_games(filter: filter_params, sort: sort_param || 'release_date_desc')
  end

  def on_sale
    list_games(
      filter: filter_params.merge(on_sale: true),
      sort: sort_param || 'discount_start_date_desc'
    )
  end

  def new_releases
    list_games(
      filter: filter_params.merge(new_release: true),
      sort: sort_param || 'release_date_desc'
    )
  end

  def coming_soon
    list_games(
      filter: filter_params.merge(coming_soon: true),
      sort: sort_param || 'release_date_asc'
    )
  end

  def pre_order
    list_games(
      filter: filter_params.merge(pre_order: true),
      sort: sort_param || 'release_date_asc'
    )
  end

  def wishlist
    list_games(
      filter: filter_params.merge(wishlisted: true),
      sort: sort_param.presence
    )
  end

  def show
    result = Items::Find.result(slug: params[:slug], user: current_user)

    @game = result.item
  end

  private

  def list_games(filter:, sort:)
    result = Items::List.result(filter_params: filter, sort_param: sort, user: current_user)

    @pagy, @games = pagy(result.items)
  end

  def filter_params
    permitted_params[:q].to_h
  end

  def sort_param
    permitted_params[:sort].to_s.presence
  end

  def permitted_params
    params.permit(:sort, q: {})
  end
end
