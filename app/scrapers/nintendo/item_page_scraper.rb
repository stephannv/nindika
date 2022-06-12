# frozen_string_literal: true

module Nintendo
  class ItemPageScraper
    attr_reader :url, :data

    IMAGE_BASE_URL = "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_700"
    VIDEO_BASE_URL = "https://assets.nintendo.com/video/upload/v1"

    def initialize(url)
      @url = url
      @data = extract_data
    end

    def self.scrap(...)
      new(...).scrap
    rescue Down::Error
      {}
    end

    def scrap
      {
        release_date: extract_release_date,
        release_date_display: extract_release_date_display,
        languages: extract_languages,
        bg_color: extract_bg_color,
        headline: extract_headline,
        screenshot_urls: extract_screenshot_urls,
        video_urls: extract_video_urls,
        rom_size: extract_rom_size,
        parent_nsuids: extract_parent_nsuids
      }
    end

    private

    def extract_data
      page = Nokogiri::HTML(Down.download(url))
      JSON.parse(page.css("script#__NEXT_DATA__").text)
    end

    def extract_release_date
      data.dig("props", "pageProps", "product", "releaseDate")
    end

    def extract_release_date_display
      data.dig("props", "pageProps", "product", "releaseDateDisplay")
    end

    def extract_languages
      data.dig("props", "pageProps", "product", "supportedLanguages")
    end

    def extract_bg_color
      data.dig("props", "pageProps", "product", "backgroundColor")
    end

    def extract_headline
      data.dig("props", "pageProps", "product", "headline")
    end

    def extract_screenshot_urls
      media_data = data.dig("props", "pageProps", "product", "productGallery")

      return [] if media_data.blank?

      media_data
        .select { |i| i["resourceType"] == "image" }
        .map { |i| "#{IMAGE_BASE_URL}/#{i['publicId']}" }
    end

    def extract_video_urls
      media_data = data.dig("props", "pageProps", "product", "productGallery")

      return [] if media_data.blank?

      media_data
        .select { |i| i["resourceType"] == "video" }
        .map { |i| "#{VIDEO_BASE_URL}/#{i['publicId']}" }
    end

    def extract_rom_size
      data.dig("props", "pageProps", "product", "romFileSize")
    end

    def extract_parent_nsuids
      data.dig("props", "pageProps", "product", "parentNsuid").to_s.split(",")
    end
  end
end
