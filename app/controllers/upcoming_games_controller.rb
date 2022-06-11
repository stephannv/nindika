# frozen_string_literal: true

class UpcomingGamesController < ApplicationController
  include HasGamesListPage

  def index
    render_games_list_page(title: t(".title"), filter_overrides: { coming_soon: true })
  end
end
