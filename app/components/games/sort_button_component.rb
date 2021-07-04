# frozen_string_literal: true

module Games
  class SortButtonComponent < ViewComponent::Base
    def options
      GameExplorer::SORT_OPTIONS.keys
    end

    def sort_path(sort_option)
      url_for(sort_by: sort_option)
    end

    def dropdown_item_class(sort_option)
      active_class = request.query_parameters['sort_by'] == sort_option.to_s ? 'font-weight-bold' : nil
      helpers.class_names('dropdown-item', active_class)
    end
  end
end
