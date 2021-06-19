# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    traits_for_enum :state, PriceStates.list

    association :item

    nsuid { Faker::Number.number(digits: 16).to_s }
    regular_amount { Money.new(Faker::Number.number(digits: 2)) }
    state { PriceStates.list.sample }
    gold_points { Faker::Number.number(digits: 2) }

    trait :with_discount do
      discount_amount { Money.new(Faker::Number.number(digits: 2)) }
      discount_started_at { Faker::Date.backward(days: 30) }
      discount_ends_at { Faker::Date.forward(days: 30) }
      discount_percentage { ((1 - (discount_price.cents.to_f / regular_price.cents)) * 100).round }
    end
  end
end
