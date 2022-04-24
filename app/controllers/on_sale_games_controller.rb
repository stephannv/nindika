# frozen_string_literal: true

class OnSaleGamesController < ApplicationController
  include HasGamesListPage

  def index
    render_games_list_page(title: t('.title'), filter_overrides: { on_sale: true })
  end
end
