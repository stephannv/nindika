# frozen_string_literal: true

module App
  class SignInButtonsComponent < ViewComponent::Base
    attr_reader :current_user

    def initialize(current_user:)
      @current_user = current_user
    end

    def render?
      current_user.nil?
    end
  end
end
