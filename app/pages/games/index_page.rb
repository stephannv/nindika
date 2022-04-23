# frozen_string_literal: true

module Games
  class IndexPage < ViewComponent::Base
    attr_reader :on_sale_games, :new_games, :coming_soon_games, :new_releases_games, :trending_games

    def initialize(on_sale_games:, new_games:, coming_soon_games:, new_releases_games:, trending_games:)
      @on_sale_games = on_sale_games
      @new_games = new_games
      @coming_soon_games = coming_soon_games
      @new_releases_games = new_releases_games
      @trending_games = trending_games
    end

    private

    def i18n_scope
      'pages.games.index_page'
    end
  end
end
