# frozen_string_literal: true

class PriceHistoryChartDataBuilder
  attr_reader :relation

  def initialize(relation: PriceHistoryItem)
    @relation = relation
  end

  def self.build(...)
    new(...).build
  end

  def build
    relation.order(:reference_date).map { |item| { x: item.reference_date.iso8601, y: item.amount.to_f } }
  end
end
