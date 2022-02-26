# frozen_string_literal: true

class Items::List::SortSelectComponent < ViewComponent::Base
  OPTIONS_FOR_SELECT = ItemsSorter::OPTIONS.map { |key, options| [options[:text], key] }
end
