# frozen_string_literal: true

module Layout
  class NavbarComponent < ViewComponent::Base
    def initialize(title:, current_user:)
      @title = title
      @current_user = current_user
    end

    private

    attr_reader :title, :current_user
  end
end
