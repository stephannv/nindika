# frozen_string_literal: true

module Prices
  class InfoComponent < ViewComponent::Base
    def initialize(item:, with_ending_sale_text: false, force_float: false)
      @item = item
      @with_ending_sale_text = with_ending_sale_text
      @force_float = force_float
    end

    private

    attr_accessor :item, :with_ending_sale_text, :force_float
  end
end
