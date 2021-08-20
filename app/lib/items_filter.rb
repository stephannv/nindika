# frozen_string_literal: true

class ItemsFilter
  FILTERS = %i[
    filter_title
    filter_genre
    filter_release_date
    filter_price
    filter_on_sale
    filter_new_release
    filter_coming_soon
    filter_pre_order
  ].freeze

  def initialize(filters_form:, relation: Item)
    @relation = relation
    @filters_form = filters_form
  end

  def self.apply(...)
    new(...).apply
  end

  def apply
    FILTERS.each { |f| send(f) }

    relation
  end

  private

  attr_accessor :relation, :filters_form

  def filter_title
    self.relation = relation.search_by_title(filters_form.title).reorder('') if filters_form.title.present?
  end

  def filter_release_date
    self.relation = relation.where(release_date: filters_form.release_date_range) if filters_form.release_date_range?
  end

  def filter_price
    self.relation = relation.where(current_price_cents: filters_form.price_cents_range) if filters_form.price_range?
  end

  def filter_genre
    self.relation = relation.where('genres @> ARRAY[?]::varchar[]', filters_form.genre) if filters_form.genre.present?
  end

  %i[on_sale new_release coming_soon pre_order].each do |scope|
    define_method :"filter_#{scope}" do
      self.relation = relation.send(scope) if filters_form.public_send(scope)
    end
  end
end
