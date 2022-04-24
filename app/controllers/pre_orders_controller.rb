# frozen_string_literal: true

class PreOrdersController < ApplicationController
  include HasGamesListPage

  def index
    render_games_list_page(title: t('.title'), filter_overrides: { pre_order: true })
  end
end
