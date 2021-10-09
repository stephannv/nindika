# frozen_string_literal: true

class GameEventsGrouper
  attr_reader :game_events

  def initialize(game_events:)
    @game_events = game_events
  end

  def self.group(...)
    new(...).group
  end

  def group
    game_events
      .group_by { |event| event.created_at.beginning_of_hour }
      .transform_values do |events|
        events.group_by { |event| event.event_type_humanize }
      end
  end
end
