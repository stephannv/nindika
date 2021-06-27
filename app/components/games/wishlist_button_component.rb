# frozen_string_literal: true

module Games
  class WishlistButtonComponent < ViewComponent::Base
    attr_reader :game, :current_user, :with_text

    def initialize(game:, current_user:, with_text: false)
      @game = game
      @current_user = current_user
      @with_text = with_text
    end

    def wishlisted?
      game.try(:wishlisted)
    end

    def button_class
      wishlisted? ? active_button_class : inactive_button_class
    end

    def icon_class
      wishlisted? ? active_icon_class : inactive_icon_class
    end

    def active_icon_class
      'fas fa-bookmark'
    end

    def active_button_class
      'btn btn-action btn-secondary btn-sm text-white'
    end

    def inactive_icon_class
      'far fa-bookmark'
    end

    def inactive_button_class
      'btn btn-action btn-default btn-sm'
    end

    def button_html_attributes
      return {} if with_text

      { 'data-toggle' => 'tooltip', 'data-title' => t('.tooltip'), 'data-placement' => 'bottom' }
    end
  end
end
