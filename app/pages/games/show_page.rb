# frozen_string_literal: true

module Games
  class ShowPage < ViewComponent::Base
    attr_reader :game

    def initialize(game:)
      @game = game
    end

    private

    def meta_tags
      title = game.title
      description = game.description
      helpers.set_meta_tags(
        title: title,
        description: description,
        reverse: true,
        keywords: ['Nintendo Switch', title].join(', '),
        twitter: { card: 'summary_large_image', site: '@nindika_com' },
        og: {
          title: title,
          description: description,
          type: 'website',
          url: game_url(game.slug),
          image: game.banner_url
        }
      )
    end
  end
end
