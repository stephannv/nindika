# frozen_string_literal: true

module Notifications
  class List < Actor
    output :notifications, type: Enumerable

    def call
      self.notifications = Notification.order(created_at: :desc)
    end
  end
end
