# frozen_string_literal: true

class ItemEventsGrouper
  attr_reader :item_events

  def initialize(item_events:)
    @item_events = item_events
  end

  def self.group(...)
    new(...).group
  end

  def group
    item_events
      .group_by { |event| event.created_at.beginning_of_hour }
      .transform_values do |events|
        events.group_by { |event| event.event_type_humanize }
      end
  end
end
