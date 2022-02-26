# frozen_string_literal: true

class Items::ListComponent < ViewComponent::Base
  attr_reader :items, :pagy, :filters_form_object, :genres, :languages

  def initialize(items:, pagy:, filters_form_object:, genres:, languages:)
    @items = items
    @pagy = pagy
    @filters_form_object = filters_form_object
    @genres = genres
    @languages = languages
  end
end
