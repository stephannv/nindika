# frozen_string_literal: true

module GameFilters
  class ModalComponent < ViewComponent::Base
    attr_reader :filters_form, :current_user, :genres

    def initialize(filters_form:, current_user:, genres:)
      @filters_form = filters_form
      @current_user = current_user
      @genres = genres
    end

    def readonly?(checkbox_id)
      readonly_checkbox == checkbox_id
    end

    def readonly_checkbox
      @readonly_checkbox ||= mapped_paths[request.path]
    end

    def mapped_paths
      {
        on_sale_games_path => :on_sale,
        pre_order_games_path => :pre_order,
        coming_soon_games_path => :coming_soon,
        new_releases_games_path => :new_release
      }
    end

    def genres_options
      genres.map { |g| [I18n.t(g, scope: 'genres'), g] }
    end
  end
end
