# frozen_string_literal: true

module Analytics
  class IndexPage < ViewComponent::Base
    private

    def meta_tags
      helpers.set_meta_tags(
        title: "Analytics",
        description: t("website_description"),
        reverse: true,
        keywords: "Nintendo Switch, Games, Jogos, Nintendo, eShop",
        twitter: { card: "summary_large_image", site: "@nindika_com" },
        og: {
          title: "Analytics",
          description: t("website_description"),
          type: "website",
          url: helpers.request.url,
          image: image_url("nindika.png")
        }
      )
    end
  end
end
