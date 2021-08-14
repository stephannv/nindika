# frozen_string_literal: true

module Prices
  class CreateItemEvent < Actor
    input :price, type: Price

    BEFORE = 0
    AFTER = 1

    def call
      return unless price.saved_change_to_current_price? || price.saved_change_to_state?

      create_event(ItemEventTypes::PRICE_ADDED) if price_added?
      create_event(ItemEventTypes::DISCOUNT) if discount?
      create_event(ItemEventTypes::PERMANENT_PRICE_CHANGE) if permanent_price_change?
      create_event(ItemEventTypes::PRICE_STATE_CHANGE) if price_state_change?
    end

    private

    def create_event(event_type)
      ItemEvents::Create.call(event_type: event_type, item: price.item, price: price)
    end

    def price_added?
      newly_created_price?
    end

    def discount?
      !newly_created_price? && discount_price_added?
    end

    def permanent_price_change?
      !newly_created_price? && base_price_changed?
    end

    def price_state_change?
      !newly_created_price? && price_unavailable?
    end

    def newly_created_price?
      return unless price.saved_change_to_id?

      id_changes = price.saved_changes[:id]
      id_changes[BEFORE].nil? && id_changes[AFTER].present?
    end

    def discount_price_added?
      return unless price.saved_change_to_discount_price_cents?

      discount_price_changes = price.saved_changes[:discount_price_cents]
      discount_price_changes[BEFORE].nil? && discount_price_changes[AFTER].present?
    end

    def base_price_changed?
      return unless price.saved_change_to_base_price_cents?

      base_price_changes = price.saved_changes[:base_price_cents]
      base_price_changes[BEFORE].present? && base_price_changes[AFTER].present?
    end

    def price_unavailable?
      return unless price.saved_change_to_state?

      price.unavailable?
    end
  end
end
