# frozen_string_literal: true

module Games
  class IndexPage < ViewComponent::Base
    attr_reader :on_sale_games, :new_games, :coming_soon_games, :new_releases_games, :featured_games

    def initialize(on_sale_games:, new_games:, coming_soon_games:, new_releases_games:, featured_games:)
      @on_sale_games = on_sale_games
      @new_games = new_games
      @coming_soon_games = coming_soon_games
      @new_releases_games = new_releases_games
      @featured_games = featured_games
    end

    private

    def i18n_scope
      "pages.games.index_page"
    end

    def meta_tags
      helpers.set_meta_tags(
        description: t("website_description"),
        reverse: true,
        keywords: "Nintendo Switch, Games, Jogos, Nintendo, eShop",
        twitter: { card: "summary_large_image", site: "@nindika_com" },
        og: {
          title: "nindika",
          description: t("website_description"),
          type: "website",
          url: root_url,
          image: image_url("nindika.png")
        }
      )
    end
  end
end
