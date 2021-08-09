# frozen_string_literal: true

module App
  class UserSidebarMenuComponent < ViewComponent::Base
    attr_reader :current_user

    def initialize(current_user:)
      @current_user = current_user
    end

    def user_profile_image_url
      current_user.profile_image_url || image_url('avatar-placeholder.jpg')
    end

    def render?
      current_user.present?
    end
  end
end
