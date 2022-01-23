# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :success, :danger, :warning, :info

  rescue_from ActionPolicy::Unauthorized do
    raise ActionController::RoutingError, 'Not Found'
  end
end
