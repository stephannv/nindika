# frozen_string_literal: true
require "csv"

class WishlistsController < ApplicationController
  include HasGamesListPage

  before_action :authenticate_user!

  def show
    respond_to do |format|
      format.html do
        render_games_list_page(title: t(".title"), filter_overrides: { wishlisted: true })
      end

      format.csv do
        @games = current_user.wishlist.order(:title)
        response.headers["Content-Type"] = "text/csv"
        response.headers["Content-Disposition"] = "attachment;filename=lista-desejo-nindika.csv"
      end
    end
  end
end
