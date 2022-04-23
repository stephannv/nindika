# frozen_string_literal: true

class GamesController < ApplicationController
  include Pagy::Backend

  def index
    result = Items::LoadHomeData.result
    on_sale_games = result.on_sale_games
    new_games = result.new_games
    coming_soon_games = result.coming_soon_games
    new_releases_games = result.new_releases_games
    trending_games = result.trending_games

    render Games::IndexPage.new(on_sale_games:, new_games:, coming_soon_games:, new_releases_games:, trending_games:)
  end

  def on_sale
    list_games(on_sale: true)
    load_filter_options
  end

  def new_releases
    list_games(new_release: true)
    load_filter_options
  end

  def coming_soon
    list_games(coming_soon: true)
    load_filter_options
  end

  def pre_order
    list_games(pre_order: true)
    load_filter_options
  end

  def all
    list_games
    load_filter_options
  end

  def show
    result = Items::Find.result(slug: params[:slug], user: current_user)

    render Games::ShowPage.new(game: result.item)
  end

  private

  def list_games(filter_overrides = {})
    result = Items::List.result(
      filters_form: filters_form(filter_overrides),
      sort_param: sort_param || 'all_time_visits_desc',
      user: current_user
    )

    @pagy, @games = pagy(result.items)
  end

  def filters_form(overrides)
    @filters_form ||= GameFiltersForm.build(permitted_params[:q].to_h.merge(overrides))
  end

  def load_filter_options
    @genres = Items::ListGenres.result.genres
    @languages = Items::ListLanguages.result.languages
  end

  def sort_param
    permitted_params[:sort].to_s.presence
  end

  def permitted_params
    params.permit(:sort, q: GameFiltersForm.attribute_names)
  end
end
