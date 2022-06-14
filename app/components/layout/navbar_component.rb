# frozen_string_literal: true

module Layout
  class NavbarComponent < ViewComponent::Base
    def initialize(title:)
      @title = title
    end

    private

    attr_reader :title
  end
end
