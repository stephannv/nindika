# frozen_string_literal: true

class AllGamesController < ApplicationController
  include HasGamesListPage

  def index
    render_games_list_page(title: t('.title'))
  end
end
