# frozen_string_literal: true

class NewReleasesController < ApplicationController
  include HasGamesListPage

  def index
    render_games_list_page(title: t(".title"), filter_overrides: { new_release: true })
  end
end
