# frozen_string_literal: true

module Items
  class UpdateFlags < Actor
    def call
      Item.transaction do
        unmark_flags
        mark_coming_soon_items
        mark_new_release_items
        mark_on_sale_items
        mark_pre_order_items
      end
    end

    private

    def unmark_flags
      Item.update_all(on_sale: false, new_release: false, coming_soon: false, pre_order: false)
    end

    def mark_coming_soon_items
      Item.where(release_date: Time.zone.tomorrow..2.weeks.from_now).update_all(coming_soon: true)
    end

    def mark_new_release_items
      Item.where(release_date: 2.weeks.ago..Time.zone.today).update_all(new_release: true)
    end

    def mark_on_sale_items
      Item.joins(:price).where.not(price: { discount_price_cents: nil }).update_all(on_sale: true)
    end

    def mark_pre_order_items
      Item.joins(:price).where(price: { state: PriceStates::PRE_ORDER }).update_all(pre_order: true)
    end
  end
end
