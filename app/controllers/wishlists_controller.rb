# frozen_string_literal: true

class WishlistsController < ApplicationController
  include HasGamesListPage

  before_action :authenticate_user!

  def show
    render_games_list_page(title: t(".title"), filter_overrides: { wishlisted: true })
  end
end
