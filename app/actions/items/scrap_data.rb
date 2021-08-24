# frozen_string_literal: true

module Items
  class ScrapData < Actor
    input :item, type: Item

    def call
      data = NintendoGamePageScraper.scrap(item.website_url)
      parsed_languages = parse_languages(data[:languages])
      parsed_bytesize = parse_bytesize(data[:size])
      item.update!(languages: parsed_languages, bytesize: parsed_bytesize, last_scraped_at: Time.zone.now)
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
