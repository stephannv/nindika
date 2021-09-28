# frozen_string_literal: true

class MoneyEntity < BaseEntity
  expose(:value) { |amount| amount.to_d.to_s }
  expose(:currency) { |amount| amount.currency.iso_code }
  expose :formatted
end
