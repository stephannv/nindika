# frozen_string_literal: true

module Items
  class ScrapData < Actor
    input :item, type: Item

    LANGUAGES = {
      "American English" => "Inglês Americano",
      "Brazilian Portuguese" => "Português Brasileiro",
      "British English" => "Inglês Britânico",
      "Canadian French" => "Francês Canadense",
      "Dutch" => "Holandês",
      "French" => "Francês",
      "German" => "Alemão",
      "Italian" => "Italiano",
      "Japanese" => "Japonês",
      "Korean" => "Coreano",
      "Latin American Spanish" => "Espanhol Latino",
      "Portuguese" => "Português",
      "Russian" => "Russo",
      "Simplified Chinese" => "Chinês Simplificado",
      "Spanish" => "Espanhol",
      "Traditional Chinese" => "Chinês Tradicional"
    }.freeze

    def call
      data = Nintendo::ItemPageScraper.scrap(item.website_url)
      attributes = prepare_attributes(data)

      item.update!(attributes)
    end

    private

    def prepare_attributes(data)
      {
        release_date: parse_release_date(data[:release_date]),
        release_date_display: parse_release_date_display(data),
        languages: parse_languages(data[:languages]),
        bg_color: data[:bg_color],
        headline: data[:headline],
        screenshot_urls: data[:screenshot_urls].to_a,
        video_urls: data[:video_urls].to_a,
        rom_size: parse_rom_size(data[:rom_size]),
        parent_ids: find_parent_ids(data[:parent_nsuids]),
        last_scraped_at: Time.zone.now
      }
    end

    def parse_release_date(date)
      date.to_date
    rescue StandardError
      Date.parse("31/12/2049")
    end

    def parse_release_date_display(data)
      data[:release_date_display] || data[:release_date].to_date.to_s
    rescue StandardError
      "TBD"
    end

    def parse_languages(languages)
      languages.to_a.map { |l| LANGUAGES[l] || l }
    end

    def parse_rom_size(rom_size)
      rom_size.to_i if rom_size.present?
    end

    def find_parent_ids(parent_nsuids)
      return if parent_nsuids.blank?

      Item.where(nsuid: parent_nsuids).pluck(:id)
    end
  end
end
