# frozen_string_literal: true

module App
  class SidebarComponent < ViewComponent::Base
    attr_reader :current_user

    def initialize(current_user:)
      @current_user = current_user
    end

    def sidebar_link_class(href)
      default_classes = %w[sidebar-link sidebar-link-with-icon font-weight-semi-bold]
      active_class = helpers.request.path == href ? 'active' : ''
      helpers.class_names(default_classes, active_class)
    end
  end
end
