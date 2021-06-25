# frozen_string_literal: true

class ItemsFilter
  FILTERS = %i[
    filter_title
    filter_on_sale
    filter_new_release
    filter_coming_soon
    filter_pre_order
  ].freeze

  def initialize(relation = Item, params = {})
    @relation = relation
    @params = params || {}
  end

  def self.apply(relation, params)
    new(relation, params).apply
  end

  def apply
    FILTERS.each { |f| send(f) }

    relation
  end

  private

  attr_accessor :relation, :params

  def filter_title
    self.relation = if params[:title].present?
      relation.search_by_title(params[:title]).reorder('')
    else
      relation
    end
  end

  %i[on_sale new_release coming_soon pre_order].each do |scope|
    define_method :"filter_#{scope}" do
      self.relation = if params[scope]
        relation.send(scope)
      else
        relation
      end
    end
  end
end
