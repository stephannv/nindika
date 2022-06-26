# frozen_string_literal: true

module Items
  class LoadHomeData < Actor
    output :trending_games, type: Enumerable
    output :coming_soon_games, type: Enumerable
    output :new_releases_games, type: Enumerable
    output :on_sale_games, type: Enumerable
    output :new_games, type: Enumerable

    def call
      load_trending_games
      load_coming_soon_games
      load_new_releases_games
      load_on_sale_games
      load_new_games
    end

    private

    def load_trending_games
      self.trending_games = Item.only_games.including_prices.order(last_week_visits: :desc).limit(3)
    end

    def load_coming_soon_games
      self.coming_soon_games = Item.only_games.coming_soon.including_prices.order(all_time_visits: :desc).limit(4)
    end

    def load_new_releases_games
      self.new_releases_games = Item.only_games.including_prices.new_release.order(all_time_visits: :desc).limit(4)
    end

    def load_on_sale_games
      self.on_sale_games = Item.only_games.with_prices.on_sale.order("prices.discount_started_at DESC").limit(4)
    end

    def load_new_games
      self.new_games = Item.only_games.including_prices.order(created_at: :desc).limit(4)
    end
  end
end
