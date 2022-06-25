# frozen_string_literal: true

module Prices
  class InfoComponent < ViewComponent::Base
    def initialize(item:, with_ending_sale_text: false)
      @item = item
      @with_ending_sale_text = with_ending_sale_text
    end

    private

    attr_accessor :item, :with_ending_sale_text
  end
end
