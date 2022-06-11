# frozen_string_literal: true

require "active_support/concern"

module HasGamesListPage
  extend ActiveSupport::Concern

  included do
    include Pagy::Backend
  end

  private

  def render_games_list_page(title:, filter_overrides: {})
    filters_form_object = build_filters(filter_overrides)
    games = list_games(filters_form_object:)
    pagy, games = pagy(games)
    filters_data = load_filter_options

    render Games::ListPage.new(title:, games:, pagy:, filters_form_object:, filters_data:)
  end

  def list_games(filters_form_object:)
    result = Items::List.result(filters_form: filters_form_object, sort_param: sort_param)
    result.items
  end

  def build_filters(overrides)
    GameFiltersForm.build(permitted_params[:q].to_h.merge(overrides))
  end

  def load_filter_options
    genres = Items::ListGenres.result.genres
    languages = Items::ListLanguages.result.languages

    { genres:, languages: }
  end

  def sort_param
    permitted_params[:sort].to_s.presence || "all_time_visits_desc"
  end

  def permitted_params
    params.permit(:sort, q: GameFiltersForm.attribute_names)
  end
end
