# frozen_string_literal: true

module App
  class ToastComponent < ViewComponent::Base
    TYPE = 0
    MESSAGE = 1

    def message
      helpers.flash.first[MESSAGE]
    end

    def type
      helpers.flash.first[TYPE]
    end

    def alert_class
      "alert-#{type}"
    end

    def render?
      helpers.flash.any?
    end
  end
end
