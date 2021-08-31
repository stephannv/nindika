# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :success, :danger, :warning, :info

  rescue_from Pagy::OverflowError, with: :redirect_to_404

  def redirect_to_404
    raise ActionController::RoutingError, 'Not Found'
  end
end
