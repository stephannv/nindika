# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def pagy_url_for(pagy, page)
    params = request.query_parameters.merge(pagy.vars[:page_param] => page)
    url_for(params)
  end
end
