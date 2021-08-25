# frozen_string_literal: true

class NintendoGamePageScraper
  attr_reader :url, :page

  def initialize(url)
    @url = url
  end

  def self.scrap(...)
    new(...).scrap
  end

  def scrap
    fetch_page
    { languages: languages, size: size, screenshot_urls: screenshot_urls }
  rescue Down::NotFound
    {}
  end

  def fetch_page
    @page = Nokogiri::HTML(Down.download(url))
  end

  def languages
    page.css('dd.languages').first&.content&.split(', ')
  end

  def screenshot_urls
    page.css('product-gallery-item[type="image"]').pluck(:src)
  end

  def size
    page.css('dd[itemprop="romSize"]').first&.content
  end
end
