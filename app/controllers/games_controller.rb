# frozen_string_literal: true

class GamesController < ApplicationController
  include Pagy::Backend

  def index
    result = Items::List.result
    @pagy, @games = pagy(result.items)
  end
end
