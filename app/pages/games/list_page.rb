# frozen_string_literal: true

module Games
  class ListPage < ViewComponent::Base
    attr_reader :title, :games, :pagy, :filters_form_object, :genres, :languages

    def initialize(title:, games:, pagy:, filters_form_object:, filters_data:)
      @title = title
      @games = games
      @pagy = pagy
      @filters_form_object = filters_form_object
      @genres = filters_data[:genres]
      @languages = filters_data[:languages]
    end

    private

    def i18n_scope
      "pages.games.list_page"
    end

    def meta_tags
      helpers.set_meta_tags(
        title: title,
        description: t("website_description"),
        reverse: true,
        keywords: "Nintendo Switch, Games, Jogos, Nintendo, eShop",
        twitter: { card: "summary_large_image", site: "@nindika_com" },
        og: {
          title: title,
          description: t("website_description"),
          type: "website",
          url: helpers.request.url,
          image: image_url("nindika.png")
        }
      )
    end
  end
end
