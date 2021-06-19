# frozen_string_literal: true

FactoryBot.define do
  factory :price_history_item do
    association :price
    reference_date { Faker::Date.backward(days: 30) }
    amount { Money.new(Faker::Number.number(digits: 2)) }
  end
end
