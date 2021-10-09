# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameEventsGrouper, type: :lib do
  subject(:grouped_game_events) { described_class.group(game_events: GameEvent.all) }

  let!(:game_event_a) { create(:game_event, created_at: Time.zone.tomorrow) }
  let!(:game_event_b) { create(:game_event, :game_added, created_at: Time.zone.yesterday) }
  let!(:game_event_c) { create(:game_event, :price_added, created_at: Time.zone.yesterday, title: 'Astral') }
  let!(:game_event_d) { create(:game_event, :price_added, created_at: Time.zone.yesterday, title: 'Zelda') }

  describe '#group' do
    it 'groups game events by datetime and event type' do
      expect(grouped_game_events).to eq(
        {
          game_event_a.created_at.beginning_of_hour => {
            game_event_a.event_type_humanize => [game_event_a]
          },
          game_event_b.created_at.beginning_of_hour => {
            game_event_b.event_type_humanize => [game_event_b],
            game_event_c.event_type_humanize => [game_event_c, game_event_d]
          }
        }
      )
    end
  end
end
