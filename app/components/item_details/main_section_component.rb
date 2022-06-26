# frozen_string_literal: true

module ItemDetails
  class MainSectionComponent < ViewComponent::Base
    def initialize(item:)
      @item = item
    end

    private

    attr_reader :item

    def disable_download_button
      item.price.nil? || item.price.unavailable? || item.price.unreleased?
    end

    def download_button_text
      if disable_download_button
        t(".unavailable")
      elsif item.price.current_price.zero?
        t(".free_download")
      else
        t(".buy_now")
      end
    end
  end
end
