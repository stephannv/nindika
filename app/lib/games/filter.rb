# frozen_string_literal: true

module Games
  class Filter
    FILTERS = %i[
      filter_title
      filter_genre
      filter_language
      filter_release_date
      filter_price
      filter_on_sale
      filter_new_release
      filter_coming_soon
      filter_pre_order
    ].freeze

    def initialize(filter_form_object:, relation: Game)
      @relation = relation
      @filter_form_object = filter_form_object
    end

    def self.apply(...)
      new(...).apply
    end

    def apply
      FILTERS.each { |f| send(f) }

      relation
    end

    private

    attr_accessor :relation, :filter_form_object

    def filter_title
      return if filter_form_object.title.blank?

      self.relation = relation.search_by_title(filter_form_object.title).reorder('')
    end

    def filter_release_date
      return unless filter_form_object.release_date_range?

      self.relation = relation.where(release_date: filter_form_object.release_date_range)
    end

    def filter_price
      return unless filter_form_object.price_range?

      self.relation = relation.where(current_price_cents: filter_form_object.price_cents_range)
    end

    def filter_genre
      return if filter_form_object.genre.blank?

      self.relation = relation.where('genres @> ARRAY[?]::varchar[]', filter_form_object.genre)
    end

    def filter_language
      return if filter_form_object.language.blank?

      self.relation = relation.where('languages @> ARRAY[?]::varchar[]', filter_form_object.language)
    end

    %i[on_sale new_release coming_soon pre_order].each do |attribute|
      define_method :"filter_#{attribute}" do
        self.relation = relation.where(attribute => true) if filter_form_object.public_send(attribute)
      end
    end
  end
end
