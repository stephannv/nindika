# frozen_string_literal: true

module Layout
  class UserMenuComponent < ViewComponent::Base
    def initialize(current_user:)
      @current_user = current_user
    end

    private

    attr_reader :current_user

    def user_profile_image_url
      current_user.profile_image_url || current_user.placeholder_avatar_url
    end
  end
end
