# frozen_string_literal: true

class GamesController < ApplicationController
  def index
    result = Items::LoadHomeData.result(current_user: current_user)

    render Games::IndexPage.new(
      on_sale_games: result.on_sale_games,
      new_games: result.new_games,
      coming_soon_games: result.coming_soon_games,
      new_releases_games: result.new_releases_games,
      featured_games: result.featured_games
    )
  end

  def show
    result = Items::Find.result(slug: params[:slug], current_user: current_user)

    render Games::ShowPage.new(game: result.item)
  end
end
