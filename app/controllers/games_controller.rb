# frozen_string_literal: true

class GamesController < ApplicationController
  include Pagy::Backend

  def index
    result = Items::List.result(filter_params: params[:q], sort_param: params[:sort], current_user: current_user)

    @pagy, @games = pagy(result.items)
  end

  def show
    result = Items::Find.result(slug: params[:slug], current_user: current_user)

    @game = result.item
  end
end
