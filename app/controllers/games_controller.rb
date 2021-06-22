# frozen_string_literal: true

class GamesController < ApplicationController
  include Pagy::Backend

  def index
    result = Items::List.result(search_term: params[:search])
    @pagy, @games = pagy(result.items)
  end

  def show
    result = Items::Find.result(slug: params[:slug])

    @game = result.item
  end
end
