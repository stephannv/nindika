# frozen_string_literal: true

module ItemDetails
  class ThumbnailsSectionComponent < ViewComponent::Base
    def initialize(item:)
      @item = item
    end

    private

    attr_reader :item
  end
end
