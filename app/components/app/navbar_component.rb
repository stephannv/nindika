# frozen_string_literal: true

module App
  class NavbarComponent < ViewComponent::Base
    def active_class(path)
      'active' if helpers.request.path == path
    end
  end
end
