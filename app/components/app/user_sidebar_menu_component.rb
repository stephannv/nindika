# frozen_string_literal: true

module App
  class UserSidebarMenuComponent < ViewComponent::Base
    attr_reader :current_user

    def initialize(current_user)
      @current_user = current_user
    end

    def render?
      current_user.present?
    end
  end
end
