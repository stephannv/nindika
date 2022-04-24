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

  def readonly_checkbox?(checkbox_id)
    readonly_checkbox == checkbox_id
  end

  def readonly_checkbox
    @readonly_checkbox ||= mapped_paths_for_readonly_checkbox[request.path]
  end

  def mapped_paths_for_readonly_checkbox
    {
      on_sale_games_path => :on_sale,
      pre_orders_path => :pre_order,
      upcoming_games_path => :coming_soon,
      new_releases_path => :new_release
    }
  end
end
