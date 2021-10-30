# frozen_string_literal: true

module Games
  class FilterFormObject
    include ActiveModel::Attributes
    include ActiveModel::AttributeAssignment

    attribute :title, :string
    attribute :genre, :string
    attribute :language, :string

    attribute :release_date_gteq, :date
    attribute :release_date_lteq, :date

    attribute :price_gteq, :integer
    attribute :price_lteq, :integer

    attribute :on_sale, :boolean
    attribute :new_release, :boolean
    attribute :coming_soon, :boolean
    attribute :pre_order, :boolean

    attribute :wishlisted, :boolean
    attribute :include_hidden, :boolean
    attribute :only_hidden, :boolean

    def self.build(attributes = {})
      form = new
      form.assign_attributes(attributes)
      form
    end

    def release_date_range?
      release_date_gteq.present? || release_date_lteq.present?
    end

    def release_date_range
      release_date_gteq..release_date_lteq
    end

    def price_range?
      price_gteq.present? || price_lteq.present?
    end

    def price_cents_range
      price_gteq.try(:*, 100)..price_lteq.try(:*, 100)
    end
  end
end
