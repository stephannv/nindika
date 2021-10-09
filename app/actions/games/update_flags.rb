# frozen_string_literal: true

module Games
  class UpdateFlags < Actor
    def call
      Game.transaction do
        unmark_flags
        mark_coming_soon_games
        mark_new_release_games
        mark_on_sale_games
        mark_pre_order_games
      end
    end

    private

    def unmark_flags
      Game.update_all(on_sale: false, new_release: false, coming_soon: false, pre_order: false)
    end

    def mark_coming_soon_games
      Game.where(release_date: Time.zone.tomorrow..2.weeks.from_now).update_all(coming_soon: true)
    end

    def mark_new_release_games
      Game.where(release_date: 2.weeks.ago..Time.zone.today).update_all(new_release: true)
    end

    def mark_on_sale_games
      Game.joins(:price).where.not(price: { discount_price_cents: nil }).update_all(on_sale: true)
    end

    def mark_pre_order_games
      Game.joins(:price).where(price: { state: PriceStates::PRE_ORDER }).update_all(pre_order: true)
    end
  end
end
