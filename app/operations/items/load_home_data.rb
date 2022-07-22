# frozen_string_literal: true

module Items
  class LoadHomeData < Actor
    input :current_user, type: User, default: nil

    output :featured_games, type: Enumerable
    output :coming_soon_games, type: Enumerable
    output :new_releases_games, type: Enumerable
    output :on_sale_games, type: Enumerable
    output :new_games, type: Enumerable

    def call
      load_featured_games
      load_coming_soon_games
      load_new_releases_games
      load_on_sale_games
      load_new_games
    end

    private

    def load_featured_games
      self.featured_games = list_games(sort_param: "wishlists_count_desc").limit(50).sample(3)
    end

    def load_coming_soon_games
      self.coming_soon_games = list_games(filters: { coming_soon: true }).limit(4)
    end

    def load_new_releases_games
      self.new_releases_games = list_games(filters: { new_release: true }).limit(4)
    end

    def load_on_sale_games
      self.on_sale_games = list_games(sort_param: "discount_start_date_desc", filters: { on_sale: true }).limit(4)
    end

    def load_new_games
      self.new_games = list_games(sort_param: "created_at_desc").limit(4)
    end

    def list_games(sort_param: "all_time_visits_desc", filters: {})
      filters_form = GameFiltersForm.build(filters)
      result = Items::List.result(sort_param: sort_param, filters_form: filters_form, current_user: current_user)

      result.items
    end
  end
end
