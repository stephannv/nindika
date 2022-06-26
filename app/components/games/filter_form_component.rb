# frozen_string_literal: true

module Games
  class FilterFormComponent < ViewComponent::Base
    def initialize(filters_form_object:, genres:, languages:)
      @filters_form_object = filters_form_object
      @genres = genres
      @languages = languages
    end

    private

    attr_reader :filters_form_object, :genres, :languages

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
end
