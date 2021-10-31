# frozen_string_literal: true

class GameEntity < BaseEntity
  expose :id
  expose :title
  expose :slug
  expose :banner_url
  expose :price, using: PriceEntity

  with_options if: { type: :full } do
    expose :description
    expose :website_url
    expose :release_date_display
    expose :publishers
    expose :developers
    expose :genres do |game|
      game.genres.sort.map { |g| I18n.t(g, scope: 'genres') }
    end

    expose :languages do |game|
      game.languages.sort.map { |l| { code: l, text: I18nData.languages('PT-BR')[l] } }
    end

    expose :bytesize do |game|
      game.bytesize.present? ? ByteSize.new(game.bytesize).to_s : 'N/A'
    end
  end
end
