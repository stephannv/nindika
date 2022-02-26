# frozen_string_literal: true

class Items::List::FilterComponent < ViewComponent::Base
  attr_reader :filters_form_object, :genres, :languages

  def initialize(filters_form_object:, genres:, languages:)
    @filters_form_object = filters_form_object
    @genres = genres
    @languages = languages
  end

  def genres_options
    genres.map { |g| [I18n.t(g, scope: 'genres'), g] }
  end

  def languages_options
    languages.map { |l| [I18nData.languages('PT-BR')[l], l] }
  end
end
