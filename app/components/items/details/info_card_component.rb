# frozen_string_literal: true

class Items::Details::InfoCardComponent < ViewComponent::Base
  attr_reader :item

  def initialize(item:)
    @item = item
  end

  def rom_size
    item.rom_size.present? ? ByteSize.new(item.rom_size).to_s : "N/A"
  end

  def languages
    item.languages.map { |lang| I18nData.languages("PT-BR")[lang]&.split(";")&.first }
  end

  def genres
    item.genres.map { |genre| I18n.t(genre, scope: "genres") }
  end
end
