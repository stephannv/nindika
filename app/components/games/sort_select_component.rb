# frozen_string_literal: true

module Games
  class SortSelectComponent < ViewComponent::Base
    OPTIONS_FOR_SELECT = ItemsSorter::OPTIONS.map { |key, options| [options[:text], key] }

    def initialize(selected:)
      @selected = selected
    end

    def call
      select_tag "sort",
        options_for_select(OPTIONS_FOR_SELECT, selected),
        class: "select select-bordered w-full max-w-xs",
        data: { controller: "sort-select", action: "sort-select#makeRequest" }
    end

    private

    attr_reader :selected
  end
end
