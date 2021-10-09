# frozen_string_literal: true

module Games
  class ScrapData < Actor
    input :game, type: Game

    def call
      data = NintendoGamePageScraper.scrap(game.website_url)
      parsed_languages = parse_languages(data[:languages])
      parsed_bytesize = parse_bytesize(data[:size])
      game.update!(
        languages: parsed_languages,
        bytesize: parsed_bytesize,
        screenshot_urls: data[:screenshot_urls].to_a,
        last_scraped_at: Time.zone.now
      )
    end

    private

    def parse_languages(languages)
      languages.to_a.map { |l| I18nData.language_code(l) }
    end

    def parse_bytesize(size)
      ByteSize.new(size).to_i if size.present?
    end
  end
end
