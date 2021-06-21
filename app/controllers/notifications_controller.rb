# frozen_string_literal: true

class NotificationsController < ApplicationController
  include Pagy::Backend

  def index
    result = Notifications::List.result
    @pagy, @notifications = pagy(result.notifications)
  end
end
