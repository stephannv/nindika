# frozen_string_literal: true

class NotificationsController < ApplicationController
  include Pagy::Backend

  def all
    result = ItemEvents::List.result

    @pagy, item_events = pagy(result.item_events, items: 60)
    @grouped_events = ItemEventsGrouper.group(item_events: item_events)
  end
end
