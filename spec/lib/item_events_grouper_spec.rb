# frozen_string_literal: true

require "rails_helper"

RSpec.describe ItemEventsGrouper, type: :lib do
  subject(:grouped_item_events) { described_class.group(item_events: ItemEvent.all) }

  let!(:item_event_a) { create(:item_event, created_at: Time.zone.tomorrow) }
  let!(:item_event_b) { create(:item_event, :game_added, created_at: Time.zone.yesterday) }
  let!(:item_event_c) { create(:item_event, :price_added, created_at: Time.zone.yesterday, title: "Astral") }
  let!(:item_event_d) { create(:item_event, :price_added, created_at: Time.zone.yesterday, title: "Zelda") }

  describe "#group" do
    it "groups item events by datetime and event type" do
      expect(grouped_item_events).to eq(
        {
          item_event_a.created_at.beginning_of_hour => {
            item_event_a.event_type_humanize => [item_event_a]
          },
          item_event_b.created_at.beginning_of_hour => {
            item_event_b.event_type_humanize => [item_event_b],
            item_event_c.event_type_humanize => [item_event_c, item_event_d]
          }
        }
      )
    end
  end
end
