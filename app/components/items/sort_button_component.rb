# frozen_string_literal: true

module Items
  class SortButtonComponent < ViewComponent::Base
    def options
      ItemsSorter::OPTIONS.map { |key, options| { param: key, text: options[:text] } }
    end

    def sort_path(sort_option)
      query_params = request.query_parameters.merge('sort' => sort_option).to_param
      "#{request.path}?#{query_params}"
    end

    def dropdown_item_class(sort_option)
      active_class = request.query_parameters['sort'] == sort_option.to_s ? 'font-weight-bold' : nil
      helpers.class_names('dropdown-item', active_class)
    end
  end
end
